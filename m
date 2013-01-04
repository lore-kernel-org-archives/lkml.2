Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3ADQ15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:27:57 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:41772 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3ADQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:27:53 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXrQ4aq+cKXj3qEwnhtTGPBfHcJ6q_zTm3xSBUUh9W8dQ@mail.gmail.com>
References: <CA+icZUUCB3K1=DuM6Nonu+Qc+qg3cM_ODk9TDZ-uYCfLVOhrdw@mail.gmail.com>
	<CA+icZUXrQ4aq+cKXj3qEwnhtTGPBfHcJ6q_zTm3xSBUUh9W8dQ@mail.gmail.com>
Date: Fri, 4 Jan 2013 17:27:50 +0100
Message-ID: <CA+icZUVBdsAa7ZA7e_UNpBsAOpVOXcawhUncbHNdkC-MGY4qLw@mail.gmail.com>
Subject: Re: [3.8-{rc1,rc2}] ata1.00: failed to get Identify Device Data,
 Emask 0x1
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Shane Huang <shane.huang@amd.com>, Aaron Lu <aaron.lu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 4:59 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Jan 4, 2013 at 4:40 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi,
>>
>> I noticed messages like the following in my syslogs with Linux
>> v3.8-rc1 and v3.8-rc2:
>>
>> ata1.00: failed to get Identify Device Data, Emask 0x1
>>
>> In this Samsung ultrabook there exists a small SSD and a 500GiB HDD.
>> I had no look which of the two is "ata1" or "ata2".
>> NOTE: With ata2 I do not see the messages.
>> I haven't checked older Linux-kernel versions.
>>
>> I followed the thread in [1] a bit and Aaron Lu pointed to the commit
>> which causes these messages.
>> Shane wanted to submit a patch [3] which I first didn't found.
>> But I guess it's the one from [4], building right now...
>>
>
> [ monologue ]
>
> YES, that patch [4] fixes the problem here.
> ata1 is the internal HDD drive and ata2 the SSD.
>
> Jeff, didn't you do a git-pull-request-for-3.8 with "upstream-linus" GIT branch?
>
> - Sedat -
>
> [1] http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=shortlog;h=refs/tags/upstream-linus
>
> P.S.: Excerpts from new kernel's dmesg checking ATA stuff...
>
> $ dmesg | egrep -i 'ata1|ata2|libata|ahci|scsi'
> [    0.172529] SCSI subsystem initialized
> [    0.172532] ACPI: bus type scsi registered
> [    0.172577] libata version 3.00 loaded.
> [    0.273212] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 252)
> [    0.286268] ahci 0000:00:1f.2: version 3.0
> [    0.286329] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
> [    0.286368] ahci: SSS flag set, parallel bus scan disabled
> [    0.300666] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6
> Gbps 0x1b impl SATA mode
> [    0.300682] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm
> led clo pio slum part ems sxs apst
> [    0.300698] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.324967] scsi0 : ahci
> [    0.325034] scsi1 : ahci
> [    0.325091] scsi2 : ahci
> [    0.325148] scsi3 : ahci
> [    0.325202] scsi4 : ahci
> [    0.325255] scsi5 : ahci
> [    0.325288] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port
> 0xf0708100 irq 40
> [    0.325294] ata2: SATA max UDMA/133 abar m2048@0xf0708000 port
> 0xf0708180 irq 40
> [    0.644494] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    0.645724] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
> [    0.645742] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    0.646987] ata1.00: configured for UDMA/133
> [    0.647248] scsi 0:0:0:0: Direct-Access     ATA      Hitachi
> HTS54505 GG2O PQ: 0 ANSI: 5
> [    0.647419] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.657964] sd 0:0:0:0: [sda] Attached SCSI disk
> [    0.964266] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    0.964889] ata2.00: ATA-8: SanDisk iSSD P4 16GB, SSD 9.14, max UDMA/133
> [    0.964896] ata2.00: 31277232 sectors, multi 1: LBA48
> [    0.965579] ata2.00: configured for UDMA/133
> [    0.965794] scsi 1:0:0:0: Direct-Access     ATA      SanDisk iSSD
> P4  SSD  PQ: 0 ANSI: 5
> [    0.965955] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    0.967281] sd 1:0:0:0: [sdb] Attached SCSI disk
>
> [ /monologue ]
>
>> Hope this helps a bit to narrow down the problem.
>>
>> Regards,
>> - Sedat -
>>
>> [1] https://lkml.org/lkml/2012/10/16/557
>> [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=65fe1f0f66a57380229a4ced844188103135f37b
>> [3] https://lkml.org/lkml/2012/11/16/369
>> [4] http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=patch;h=de90cd71f68e947d3bd6c3f2ef5731ead010a768
>>
>> P.S.: Excerpts from the quoted commit:
>>
>> [ drivers/ata/libata-core.c ]
>> ...
>> +               /* check and mark DevSlp capability */
>> +               if (ata_id_has_devslp(dev->id))
>> +                       dev->flags |= ATA_DFLAG_DEVSLP;
>> +
>> +
>> +               /* Obtain SATA Settings page from Identify Device Data Log,
>> +                * which contains DevSlp timing variables etc.
>> +                * Exclude old devices with ata_id_has_ncq()
>> +                */
>> +               if (ata_id_has_ncq(dev->id)) {
>> +                       err_mask = ata_read_log_page(dev,
>> +                                                    ATA_LOG_SATA_ID_DEV_DATA,
>> +                                                    ATA_LOG_SATA_SETTINGS,
>> +                                                    dev->sata_settings,
>> +                                                    1);
>> +                       if (err_mask)
>> +                               ata_dev_dbg(dev,
>> +                                           "failed to get Identify
>> Device Data, Emask 0x%x\n",
>> +                                           err_mask);
>> +               }
>> +
>> - EOT -

...linux-ide folks all on holidays :-).

OK, I see the patch I mentioned to fix the problem was later reverted [1].
The real fix is "libata: replace sata_settings with devslp_timing" [2].

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8349e5aeaadd160b7cce554a62a05be4b2d894aa
[2] http://marc.info/?l=linux-ide&m=135575778031435&w=2
