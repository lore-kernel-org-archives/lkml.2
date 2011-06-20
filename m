Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1FTP5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:57:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45855 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1FTP5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v1miiMx9kXWSnLloSrrBd6nsNljKD/BlozUDI8QgLiLQNzk2DIlyA+g3uo8pTNHzF0
         xozbjrZYg1p7GQPb1Zarkfrbc4iwPbVIdwocwnLtK4hVoPlmZI91Fy/K1KglIWngAkcF
         gZbk7DsLq2K3BE/XNraXaRIuxfh989MVMRPdY=
MIME-Version: 1.0
In-Reply-To: <BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
	<Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
	<20110620151522.GN14262@legolas.emea.dhcp.ti.com>
	<BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
	<20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
	<BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
Date: Mon, 20 Jun 2011 17:57:31 +0200
Message-ID: <BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
From: Skacore Systems <skacore.systems@gmail.com>
To: balbi@ti.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Viliam Mateicka <viliam.mateicka@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh and I've finally cloned the mainline git. So here it's the last try.
I hope the TI people will not sabotage the Samsung's drivers any way longer !!!

Vilo

diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 100f263..b6e1ca5 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1567,7 +1567,7 @@ static void s3c2410_udc_command(enum
s3c2410_udc_cmd_e cmd)
                return;

        if (udc_info->udc_command) {
-               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
+               udc_info->udc_command(cmd);
        } else if (gpio_is_valid(udc_info->pullup_pin)) {
                int value;


On Mon, Jun 20, 2011 at 5:48 PM, Skacore Systems
<skacore.systems@gmail.com> wrote:
> Ok I'm giving it up. This is just a non-sence.
> I've followed the exact rules written there, so tell me how the patch
> could be wrong.
> The rules are obsolete or you made up a new ones ?
> Regarding to the testing. If you've at least looked in to the patch
> (and you probably not giving a stupid questions about it!)
> you would know that this is 100% bug and you don't even have to
> compile to see that fix is actually working.
> And of course I've tested it on our production kernel.
> Look somehow it's gonna fix it. It must not be you,
> someone will just (I hope Samsung's people do care about their stuff) do it.
> The amount of time I and you've put into this discussion is just pure waste.
>
> Vilo
>
>
> On Mon, Jun 20, 2011 at 5:36 PM, Felipe Balbi <balbi@ti.com> wrote:
>> Hi,
>>
>> On Mon, Jun 20, 2011 at 05:20:02PM +0200, Skacore Systems wrote:
>>> I've been exactly following
>>> http://www.kernel.org/doc/Documentation/SubmittingPatches:
>>>
>>> To create a patch for a single file, it is often sufficient to do:
>>>
>>>       SRCTREE= linux-2.6
>>>       MYFILE=  drivers/net/mydriver.c
>>>
>>>       cd $SRCTREE
>>>       cp $MYFILE $MYFILE.orig
>>>       vi $MYFILE      # make your change
>>>       cd ..
>>>       diff -up $SRCTREE/$MYFILE{.orig,} > /tmp/patch
>>>
>>> And that's what I've done. What do you think is wrong with it ???
>>
>> patch should be in 'p1' format to start with, not 'p0'!!
>>
>> Your commit log shouldn't include your "regards" or anything like that,
>> or that will go into the git history.
>>
>>> Subject: [PATCH] s3c2410_udc: fix custom UDC command handling
>>
>> this should be something like:
>>
>> [PATCH] usb: gadget: s3c2410_udc: fix custom UDC command handling
>>
>> we generally put the subsystem on the subject to help maintainers
>> filter patches related to them.
>>
>>> There is a bug in Samsung's UDC driver, which is completely disabling
>>> the USB device when a custom UDC command is used.
>>> Following patch seems to get the right?behavior (e.g. enabling pull-up
>>> instead of disabling then Vcc is applied).
>>
>> "seems to get the right behavior" makes me wonder if you really tested
>> this properly. Either it fixes the problem, or it doesn't. Have you
>> tried with other possible commands to see if also helps ?
>>
>>> Also I'm not in mailing list so please CC me.
>>
>> this would go to commit log, shouldn't be here.
>>
>>> Greetingz,
>>> Vilo
>>
>> this shouldn't be here either.
>>
>>> Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>
>>
>> there should be a tear line here. (---)
>>
>>> --- drivers/usb/gadget/s3c2410_udc.c.orig ? ? ? 2011-05-19
>>> 06:06:34.000000000 +0200
>>
>> this line break is bogus.
>>
>> you could have looked at any mailing list archive for properly formatted
>> patches, but instead you chose to be unpolite with the persons who are
>> giving you a "service" free of charge.
>>
>> At [1] you can find an example of a proper patch
>>
>> [1] http://marc.info/?l=linux-usb&m=130833192703040&w=2
>>
>> --
>> balbi
>>
>
