Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1GANNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:13:16 -0400
Received: from mail.bbaw.de ([194.95.188.6]:50337 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab1GANNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:13:15 -0400
Date: Fri, 1 Jul 2011 15:13:13 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110701151313.2afd48e0.taeuber@bbaw.de>
In-Reply-To: <20110701102323.3db579ad.taeuber@bbaw.de>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
	<201106060559.03131.gene.heskett@gmail.com>
	<20110606130628.e86f0c67.taeuber@bbaw.de>
	<201106060920.32257.gene.heskett@gmail.com>
	<20110606155610.69a0d17a.taeuber@bbaw.de>
	<20110607124354.06ed074e.taeuber@bbaw.de>
	<20110701102323.3db579ad.taeuber@bbaw.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.34; VDF: 7.11.10.186; host: mailhub); id=21558-lTc636
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

And now I retried with 2.6.39.2. Same result. Complete dmesg available.

I tried to create a RAID with fewer drives and with more drives but still the
same problem.

Then I tried to use RAID5 without any luck.

Then I tried to format a single disk.
# mke2fs -jF /dev/sdc

And: The problem still occurs!!!!
I could send the complete dmesg if needed.

Then I tried with »nosmp« kernel option. And bad luck again.
I could send the complete dmesg if needed.

[  760.138201] ata7.00: failed command: WRITE FPDMA QUEUED
[  760.138305] ata7.00: cmd 61/00:00:10:02:70/02:00:28:00:00/40 tag 30 ncq
262144 out [  760.138308]          res 01/04:00:10:0c:7c/00:02:28:00:00/40
Emask 0x3 (HSM violation) [  760.138563] ata7.00: status: { ERR }
[  760.138652] ata7.00: error: { ABRT }
[  760.138745] ata7: hard resetting link
[  770.160095] sas: smp task timed out or aborted
[  770.160105] drivers/scsi/mvsas/mv_sas.c 1718:mvs_abort_task:rc= 5
[  770.160110] sas: SMP task aborted and not done
[  772.170093] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device
[1]:rc= -70 [  772.170108] sas: sas_ata_hard_reset: Unable to reset I T nexus?
[  772.170112] sas: sas_ata_hard_reset: Found ATA device.
[  772.170119] ata7: follow-up softreset required but no softreset available
[  772.170252] ata7: hard resetting link

This is so simple it can't be I'm the only one with this problem!?

Regards
Lars
