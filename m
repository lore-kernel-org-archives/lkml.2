Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0HDQQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:16:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48272 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0HDQQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A/CN3Sv8HeECftTkqHJqlVWQ+i/a7JzzFmvzguAypwQb7s05kD9kNpYFI2HAjdDXmr
         fez4izglJUrh1AK0cXqxH0HIXZXghGAfNv3dns6EFTqLQJptEycPrQM5jT/VatWj4JF9
         qEXIQIMqz9IwM5QdaxhZ7JSNW34SmrGGa88xk=
MIME-Version: 1.0
In-Reply-To: <20100803115553.e4c51104.randy.dunlap@oracle.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C317C04.20500@kernel.org>
	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
	<4C32CE50.6010501@kernel.org>
	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>
	<4C341598.6040004@kernel.org>
	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
	<4C34A1D5.1090202@kernel.org>
	<AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>
	<4C34B8BE.5080504@kernel.org>
	<AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
	<4C44BD42.3030904@kernel.org>
	<7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
	<4C45AF40.7030800@kernel.org>
	<AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
	<4C483BF4.3090006@kernel.org>
	<AANLkTinwJLE=jjwG5zL8UBO91tzDpX36_W9GORKag8RK@mail.gmail.com>
	<20100803114105.7f199878.randy.dunlap@oracle.com>
	<AANLkTi=bKn3t8eD=n8tDeZrn-mXsEzFHGj46-Z5U9EGA@mail.gmail.com>
	<20100803115553.e4c51104.randy.dunlap@oracle.com>
Date: Wed, 4 Aug 2010 09:16:32 -0700
Message-ID: <AANLkTi=rt=krewXX3eLaGndqpQgdsTGF4+Z+43j92_9V@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Paul Check <paul@thechecks.ca>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 11:55 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 3 Aug 2010 11:47:25 -0700 Mark Knecht wrote:
>
>> On Tue, Aug 3, 2010 at 11:41 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> > On Mon, 2 Aug 2010 15:07:11 -0700 Mark Knecht wrote:
>> >
>> >> On Thu, Jul 22, 2010 at 5:39 AM, Tejun Heo <tj@kernel.org> wrote:
>> >>
>> >> Hi Tejun,
>> >>    I'm finally home and trying to get back to this. I'm really a bad
>> >> programmer so I don't know what I've done wrong but it seems patch
>> >> isn't happy with me.
>> >>
>> >> c2stable linux # patch --dry-run -p1 <../ata_piix-sidpr-lock.patch
>> >> patching file drivers/ata/ata_piix.c
>> >> patch: **** malformed patch at line 13:
>> >
>> > Whenever the patch file was saved on this system, line 13 of it was
>> > split (probably by an email client).  Whenever I see this, I just
>> > join (merge) that line and the next one and try again... sometimes
>> > several lines are malformed and have to be fixed like this.
>> >
>>
>> Randy,
>>    Could very well be what happened. I added line 13 (the printk) by hand
>>
>> <SNIP - ORIGINAL PATCH FILE>
>> struct piix_host_priv {
>>        const int *map;
>>        u32 saved_iocfg;
>> +       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
>>         void __iomem *sidpr;
>> };
>>
>> <SNIP - MY CHANGE BY HAND>
>> struct piix_host_priv {
>>        const int *map;
>>        u32 saved_iocfg;
>> +       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
>> +       printk("MWK - ata_sidpr patch applied!\n");
>>        void __iomem *sidpr;
>> };
>>
>> Maybe I should have just put it on the same line as the previous
>> spinlock command?
>>
>> I'll play with it and see if I can get it working.
>
>
> Ah, so you added a line to a patch file.  That means that the patch
> block header must be changed from something like this:
>
> @@ -964,12 +968,15 @@
>
> to like this:
>
> @@ -964,12 +968,16 @@
>
> Any text following the second "@@" is just a comment so it does not matter.
>
> The ,12  ,15   ,16   are all line counts. The ",12" is the number of lines
> in the before version of the patch.  The ",15" or ",16" is the number of lines
> in the after version of the patch, so you would need to increase it by 1 if
> you added one line.   Or you can just put the printk on the same line as another
> part of the patch and it won't matter.  :)
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

Thanks Randy. This helped.

OK - so I'm going to hang fire on this problem right now. As part of
this process I've updated to a 2.6.35-gentoo kernel and I'm not seeing
the problem at all so far. I've booted about 25 times over the last 3
days - warm and cold boots mixed - and so far no failures. While I've
had times in the past where earlier kernels didn't exhibit the problem
for days I don't remember a time where I got this many good boots in a
row.

As my problem didn't seem to be exactly the same as Paul's, and since
Tejun expressed surprise that his fix for Paul's issue didn't fix
mine, maybe my problem is actually something different and (hopefully)
already fixed.

I'll continue to use the machine and watch for any failures. If I get
one I'll reengage the list and go into debug mode.

Cheers,
Mark
