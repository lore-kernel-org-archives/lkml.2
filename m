Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1GAOhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:37:23 -0400
Received: from mail.bbaw.de ([194.95.188.6]:58079 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab1GAOhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:37:21 -0400
Date: Fri, 1 Jul 2011 16:37:19 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110701163719.27afc580.taeuber@bbaw.de>
In-Reply-To: <20110701151313.2afd48e0.taeuber@bbaw.de>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
	<201106060559.03131.gene.heskett@gmail.com>
	<20110606130628.e86f0c67.taeuber@bbaw.de>
	<201106060920.32257.gene.heskett@gmail.com>
	<20110606155610.69a0d17a.taeuber@bbaw.de>
	<20110607124354.06ed074e.taeuber@bbaw.de>
	<20110701102323.3db579ad.taeuber@bbaw.de>
	<20110701151313.2afd48e0.taeuber@bbaw.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.34; VDF: 7.11.10.186; host: mailhub); id=8579-Lxrmyn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same with new 2TB Seagate Constellation ES ST2000NM0011 connected to the
areca ARC1300 (mvsas).
It only takes a simple »dd if=/dev/zero of=/dev/sd_« to provoke the problem.

Connected to the onboard AMD_AHCI controller (3.0 Gbps) both disks can be
formatted. Also the dd command line doesn't harm anything.

But there are some messages in dmesg if I do this with the disks still connected to the AHCI:

# mdadm -C /dev/md3 -l5 -n3 /dev/sd[cd] missing
# mke2fs -Fj /dev/md3

in dmesg:

[ 1515.340662] md: bind<sdc>
[ 1515.378861] md: bind<sdd>
[ 1515.470912] md/raid:md3: device sdd operational as raid disk 1
[ 1515.470919] md/raid:md3: device sdc operational as raid disk 0
[ 1515.471728] md/raid:md3: allocated 3230kB
[ 1515.471798] md/raid:md3: raid level 5 active with 2 out of 3 devices,
algorit hm 2
[ 1515.471933] RAID conf printout:
[ 1515.471938]  --- level:5 rd:3 wd:2
[ 1515.471944]  disk 0, o:1, dev:sdc
[ 1515.471949]  disk 1, o:1, dev:sdd
[ 1515.472008] md3: detected capacity change from 0 to 4000797687808
[ 1515.472765]  md3: unknown partition table
[ 1918.040121] ata6.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen [ 1918.040259] ata6.00: failed command: WRITE FPDMA QUEUED
[ 1918.040367] ata6.00: cmd 61/00:00:00:00:b4/04:00:cc:00:00/40 tag 0 ncq 524288 out [ 1918.040371]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout) [ 1918.040625] ata6.00: status: { DRDY }
[ 1918.040718] ata6.00: failed command: WRITE FPDMA QUEUED
[ 1918.040822] ata6.00: cmd 61/00:08:00:04:b4/04:00:cc:00:00/40 tag 1 ncq 524288 out [ 1918.040825]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout) [ 1918.041078] ata6.00: status: { DRDY }
[ 1918.041173] ata6: hard resetting link
[ 1918.041202] ata5.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen [ 1918.041315] ata5.00: failed command: WRITE FPDMA QUEUED
[ 1918.041422] ata5.00: cmd 61/00:00:00:00:b4/04:00:cc:00:00/40 tag 0 ncq 524288 out [ 1918.041426]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout) [ 1918.041681] ata5.00: status: { DRDY }
[ 1918.041772] ata5.00: failed command: WRITE FPDMA QUEUED
[ 1918.041877] ata5.00: cmd 61/00:08:00:04:b4/04:00:cc:00:00/40 tag 1 ncq 524288 out [ 1918.041880]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout) [ 1918.042133] ata5.00: status: { DRDY }
[ 1918.042227] ata5: hard resetting link
[ 1918.590112] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1918.590155] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1918.592281] ata5.00: configured for UDMA/133
[ 1918.592297] ata5.00: device reported invalid CHS sector 0
[ 1918.592307] ata5.00: device reported invalid CHS sector 0
[ 1918.592322] ata5: EH complete
[ 1918.592804] ata6.00: configured for UDMA/133
[ 1918.592818] ata6.00: device reported invalid CHS sector 0
[ 1918.592827] ata6.00: device reported invalid CHS sector 0
[ 1918.592841] ata6: EH complete

But the format successfully completes.

Is there an important difference if the controller are onboard or connected via PCIe slot?

I'll try some more SATA controllers on monday.
In the meanwhile I'll check the ram with memtest86+ as suggested from Lee Mathers.

Have a nice weekend.
Lars
