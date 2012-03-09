Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab2CIQHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:07:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64499 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2CIQHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:07:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAF1ivSaDEfDFgF0hz3myjSc0BXhig1XGRa_uMOi=gtf2HTEMHg@mail.gmail.com>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
	<CAE5mzvgfsHD1Ku5saw+Cu7+vJAayx20=HfHfab1MrAwz3AtqJg@mail.gmail.com>
	<CAF1ivSZcGHQ-bnGasKghJ-_beDqgyZ_ug=m-7Ykr4xUphZeLqw@mail.gmail.com>
	<CAE5mzvgc60+_HOve+5wMsL7fo6jmM_sOB=_pTR1j23=RbP+uPw@mail.gmail.com>
	<CAF1ivSaDEfDFgF0hz3myjSc0BXhig1XGRa_uMOi=gtf2HTEMHg@mail.gmail.com>
Date: Fri, 9 Mar 2012 10:07:41 -0600
X-Google-Sender-Auth: JE4G3osPsaxTgL6KBCceF9qGESw
Message-ID: <CAE5mzviyg1L3HhSy4gYeLv673GN3M6JU68wwhzNBTKp6dtxTBg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
From: cwillu <cwillu@cwillu.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt <jackdachef@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> I just spent the better part of last night tracking down the specific
>>>> sources of the log entry I get when I disconnect my e-sata drive; once
>>>> it disconnects, the port is dead until I reboot; no combination of
>>>> anything I've been able to poke at in /sys or elsewhere gets it live
>>>> again.  This starts with 3.3rc1, and turns out to still work fine in
>>>> 3.2.1. Any chance it's related?
>>>>
>>>> 3.3rc5, immediately after the unplug:
>>>
>>> I tested on my machine and it's fixed by below patch.
>>> http://marc.info/?l=linux-kernel&m=132996405028746&w=2
>>>
>>> Would you please also try it?
>>
>> Building it now, and will be able to test in about 5 hours.
>
> Hi,
>
> How about the test result?

Sorry about the delay.

Just verified, that patch does fix the problem:

*disconnect drive*
[   80.474026] ata5: exception Emask 0x50 SAct 0x0 SErr 0x4090800
action 0xe frozen
[   80.474041] ata5: irq_stat 0x00400040, connection status changed
[   80.474057] ata5: SError: { HostInt PHYRdyChg 10B8B DevExch }
[   80.474064] ata5: hard resetting link
[   81.197080] ata5: SATA link down (SStatus 0 SControl 300)
[   86.197028] ata5: hard resetting link
[   86.502021] ata5: SATA link down (SStatus 0 SControl 300)
[   86.502039] ata5: limiting SATA link speed to 1.5 Gbps
[   91.502018] ata5: hard resetting link
[   91.807032] ata5: SATA link down (SStatus 0 SControl 310)
[   91.807050] ata5.00: disabled
[   91.807069] ata5: EH complete
[   91.807095] ata5.00: detaching (SCSI 4:0:0:0)
[   91.808988] sd 4:0:0:0: [sde] Synchronizing SCSI cache
[   91.810288] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   91.810305] sd 4:0:0:0: [sde] Stopping disk
[   91.810318] sd 4:0:0:0: [sde] START_STOP FAILED
[   91.810333] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  106.507666] ata5: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[  106.507683] ata5: irq_stat 0x00000040, connection status changed
[  106.507703] ata5: SError: { CommWake DevExch }
[  106.507710] ata5: limiting SATA link speed to 1.5 Gbps
[  106.507715] ata5: hard resetting link
*reconnect drive*
[  107.386022] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  107.387979] ata5.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
[  107.387985] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[  107.389253] ata5.00: configured for UDMA/133
[  107.389264] ata5: EH complete
[  107.389375] scsi 4:0:0:0: Direct-Access     ATA      WDC
WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
[  107.389551] sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[  107.389613] sd 4:0:0:0: [sde] Write Protect is off
[  107.389619] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[  107.389651] sd 4:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  107.389667] sd 4:0:0:0: Attached scsi generic sg4 type 0
[  107.803230]  sde: unknown partition table
[  107.803550] sd 4:0:0:0: [sde] Attached SCSI disk
*rejoicing*

Thanks.

--Carey
