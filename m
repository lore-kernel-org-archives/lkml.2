Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab0GAW2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:28:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49008 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0GAW2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xrezg8tw5MKnFwpKNgSx+AKTCTv5oNbYEirbD91L/562deKcFGXGN7sER2hATKow8j
         iejtHdNTi8md8yyW4uDhfRhabOPzrFTw9MUs7o4tTURmDL5pB4iqCV0DN+8q0ysl9AEX
         Zjn6XLdJQCrHZsqDGRx22hEOsKnDMlTxmSCWg=
MIME-Version: 1.0
In-Reply-To: <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
	<20100701162454.GD4152@core.coreip.homeip.net>
	<AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
Date: Fri, 2 Jul 2010 00:28:17 +0200
Message-ID: <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active 
	multiplexor, mouse won't work.)
From: Jerome Lacoste <jerome.lacoste@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 11:19 PM, Jerome Lacoste
<jerome.lacoste@gmail.com> wrote:
> On Thu, Jul 1, 2010 at 6:24 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> Hi Jerome,
>>
> [...]
>>> * the hardware is a Lenovo 3000 N100
>>
>> We already trying to disable MUX mode on Lenovo 3000 N100, see
>> drivers/input/serio/i8042-x86ia64io.h:
>>
>>        {
>>                /* Lenovo 3000 n100 */
>>                .matches = {
>>                        DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
>>                        DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
>>                },
>>        },
>>
>> What's in your dmi?
>
> System Information
>        Manufacturer: LENOVO
>        Product Name: 0768BKG
>        Version: 3000 N100
>
> according to dmidecode

Note: I will try the i8042.nomux option, but can't reboot until tomorrow.

Some information that maybe relevant:

The blacklist used to be broader but was restricted by
https://kerneltrap.org/mailarchive/git-commits-head/2008/9/7/3217784

The discussion is in particular here:
http://lkml.indiana.edu/hypermail/linux/kernel/0809.0/0316.html

which states that the problem for which one didn't want to blacklist was a:

System Information
Manufacturer: LENOVO
Product Name: 076836U
Version: 3000 N100

There seems to be many various versions of that Product Name

http://smolts.org/reports/view_profiles?profile=+3000+N100&search=Submit

I wonder if there are other versions affected by this "regression".

For example

https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/86820
points to
http://launchpadlibrarian.net/6494256/dmidecode

	Manufacturer: LENOVO
	Product Name: 0768B9G
	Version: 3000 N100

which is probably also affected

It would be nice if the message that displays "failed to resume active
multiplexor, mouse won't work." could also print out the relevant dmi
information.

That way one could use google to find potentially affected systems :)

Cheers,

Jerome
