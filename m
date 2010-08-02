Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0HBWHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:07:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56390 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0HBWHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MYdL6rwcwDw+Li8KGL6ugIlpW/SuKigTai5Ws8R+SCizQo6pUJGl+aDgA9mUFhTlwr
         dZj1g/xAcQHLIzjjTdaIN/V66AWjWlzb73VLlJLjIvEEdkdRQSNaG0tOjblfRT3bD9IA
         myvOGRlaS3rJKjAWAgJTlImXmTfo+cAnR07pY=
MIME-Version: 1.0
In-Reply-To: <4C483BF4.3090006@kernel.org>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C2F5ECB.1040505@kernel.org>
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
Date: Mon, 2 Aug 2010 15:07:11 -0700
Message-ID: <AANLkTinwJLE=jjwG5zL8UBO91tzDpX36_W9GORKag8RK@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Paul Check <paul@thechecks.ca>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 5:39 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 07/21/2010 10:54 PM, Mark Knecht wrote:
>>    Looks like I had a failure today. First one in weeks and only the
>> 3rd or 4th boot with this newer patch file. One of the two drives
>> making a RAID0 wasn't found so /dev/md11 (constructed from /dev/sdd
>> and /dev/sde) couldn't be started. I did a cold reboot and the drive
>> was found.
>>
>>    If it matters, and it probably doesn't, the failure came on a boot
>> which had a scheduled fsck to do of /dev/md5 - my main / drive. I
>> don't see how that would make a difference but I figure why leave the
>> info out. That's why the times are so much larger in the dmesg file.
>> (I think)
>>
>>    dmesg attached. I patched the Gentoo kernel if it makes a
>> difference, same as I did with the earlier patch.
>>
>> mark@c2stable ~ $ uname -a
>> Linux c2stable 2.6.34-gentoo-r2 #1 SMP PREEMPT Sun Jul 18 14:09:48 PDT
>> 2010 x86_64 Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz GenuineIntel
>> GNU/Linux
>> mark@c2stable ~ $
>
> Hmmm... that's weird.  Can you please make sure the patch is actually
> applied?  Adding a printk("XXX patch applied!\n") near other changes
> usually is easy enough.  Also, can you please apply resume-dbg-1.patch
> too and reproduce the failure and post log?
>
> Thanks.
>
> --
> tejun
>

Hi Tejun,
   I'm finally home and trying to get back to this. I'm really a bad
programmer so I don't know what I've done wrong but it seems patch
isn't happy with me.

c2stable linux # patch --dry-run -p1 <../ata_piix-sidpr-lock.patch
patching file drivers/ata/ata_piix.c
patch: **** malformed patch at line 13:

c2stable linux #

   Here's the change I tried to make to a copy of the file:

c2stable linux # cat ../ata_piix-sidpr-lock.patch
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 7409f98..3971bc0 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -158,6 +158,7 @@ struct piix_map_db {
 struct piix_host_priv {
        const int *map;
        u32 saved_iocfg;
+       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
+       printk("MWK - ata_sidpr patch applied!\n");
        void __iomem *sidpr;
 };

@@ -951,12 +952,15 @@ static int piix_sidpr_scr_read(struct ata_link *link,
                               unsigned int reg, u32 *val)
 {
        struct piix_host_priv *hpriv = link->ap->host->private_data;
+       unsigned long flags;

        if (reg >= ARRAY_SIZE(piix_sidx_map))
                return -EINVAL;

+       spin_lock_irqsave(&hpriv->sidpr_lock, flags);
        piix_sidpr_sel(link, reg);
        *val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
+       spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
        return 0;
 }

@@ -964,12 +968,15 @@ static int piix_sidpr_scr_write(struct ata_link *link,
                                unsigned int reg, u32 val)
 {
        struct piix_host_priv *hpriv = link->ap->host->private_data;
+       unsigned long flags;

        if (reg >= ARRAY_SIZE(piix_sidx_map))
                return -EINVAL;

+       spin_lock_irqsave(&hpriv->sidpr_lock, flags);
        piix_sidpr_sel(link, reg);
        iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
+       spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
        return 0;
 }

@@ -1566,6 +1573,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
        hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
        if (!hpriv)
                return -ENOMEM;
+       spin_lock_init(&hpriv->sidpr_lock);

        /* Save IOCFG, this will be used for cable detection, quirk
         * detection and restoration on detach.  This is necessary
c2stable linux #

   Maybe you can shoot back something that's done correctly and I'll
start testing.

   I've tried booting a few times. I've had 3 cold boot failures so
far. No warm boot failures. Each time it failed on cold boot a warm
boot fixed it.

Thanks,
Mark
