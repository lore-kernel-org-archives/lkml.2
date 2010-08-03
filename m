Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0HCSr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:47:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56277 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0HCSr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LBUabume0Tutgl4TT99ypUa7JQQfclNZr0OONeRYvACKVes38NAq4GfMkhMjr/uU36
         GHNGqoqeUE6fWEf/gB8nZFXqK7F70Gy2oHZPzlkT5AZDoubDuqKRXAj2habxaWuOCDbr
         G5furHuo9lDP8YP6FIGYOHgcGW+WtHrMlk9+Y=
MIME-Version: 1.0
In-Reply-To: <20100803114105.7f199878.randy.dunlap@oracle.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F61AB.9030806@kernel.org>
	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
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
Date: Tue, 3 Aug 2010 11:47:25 -0700
Message-ID: <AANLkTi=bKn3t8eD=n8tDeZrn-mXsEzFHGj46-Z5U9EGA@mail.gmail.com>
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

On Tue, Aug 3, 2010 at 11:41 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 2 Aug 2010 15:07:11 -0700 Mark Knecht wrote:
>
>> On Thu, Jul 22, 2010 at 5:39 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> Hi Tejun,
>>    I'm finally home and trying to get back to this. I'm really a bad
>> programmer so I don't know what I've done wrong but it seems patch
>> isn't happy with me.
>>
>> c2stable linux # patch --dry-run -p1 <../ata_piix-sidpr-lock.patch
>> patching file drivers/ata/ata_piix.c
>> patch: **** malformed patch at line 13:
>
> Whenever the patch file was saved on this system, line 13 of it was
> split (probably by an email client).  Whenever I see this, I just
> join (merge) that line and the next one and try again... sometimes
> several lines are malformed and have to be fixed like this.
>

Randy,
   Could very well be what happened. I added line 13 (the printk) by hand

<SNIP - ORIGINAL PATCH FILE>
struct piix_host_priv {
       const int *map;
       u32 saved_iocfg;
+       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
        void __iomem *sidpr;
};

<SNIP - MY CHANGE BY HAND>
struct piix_host_priv {
       const int *map;
       u32 saved_iocfg;
+       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
+       printk("MWK - ata_sidpr patch applied!\n");
       void __iomem *sidpr;
};

Maybe I should have just put it on the same line as the previous
spinlock command?

I'll play with it and see if I can get it working.

Thanks,
Mark
