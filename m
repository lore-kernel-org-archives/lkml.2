Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1IQCJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 22:09:06 -0400
Received: from mail.tomasu.net ([64.85.170.232]:58954 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1IQCJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 22:09:04 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: mvsas errors in 3.0
Date: Fri, 16 Sep 2011 20:02:13 -0600
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: inux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109162002.13801.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, its me again.

Just updated to 3.0 last night, after the card had locked up twice in as many
days. However, I just heard some unsettling noises come from my raid array,
like one of the disks was being re-initialized several times. spinning up and
down a few times, etc.

When I got to look at the logs, I find this:

[21051.403115] /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 2084:Release slot [0] tag[0], task [ffff88013ed982c0]:
[21051.403134] sas: sas_ata_task_done: SAS error 8a
[21051.407099] sas: Enter sas_scsi_recover_host
[21051.407099] ata14: sas eh calling libata cmd error handler
[21051.407099] ata9: sas eh calling libata port error handler
[21051.407099] ata10: sas eh calling libata port error handler
[21051.407099] ata11: sas eh calling libata port error handler
[21051.407099] ata12: sas eh calling libata port error handler
[21051.407099] ata13: sas eh calling libata port error handler
[21051.407099] ata14: sas eh calling libata port error handler
[21051.407099] sas: sas_ata_task_done: SAS error 8a
[21051.407099] ata14: failed to read log page 10h (errno=-5)
[21051.414118] ata14.00: exception Emask 0x1 SAct 0x1 SErr 0x0 action 0x6
[21051.414118] ata14.00: failed command: READ FPDMA QUEUED
[21051.417174] ata14.00: cmd 60/10:00:b0:a9:37/00:00:0e:00:00/40 tag 0 ncq 8192 in
[21051.417180]          res 01/04:00:f8:e4:c6/00:00:47:00:00/40 Emask 0x3 (HSM violation)
[21051.419797] ata14.00: status: { ERR }
[21051.421106] ata14.00: error: { ABRT }
[21051.422427] ata14: hard resetting link
[21051.422434] sas: sas_ata_hard_reset: Found ATA device.
[21051.422446] sas: sas_ata_task_done: SAS error 8a
[21051.422476] sas: sas_ata_task_done: SAS error 8a
[21051.422484] ata14.00: both IDENTIFYs aborted, assuming NODEV
[21051.422491] ata14.00: revalidation failed (errno=-2)
[21053.443487] mvsas 0000:04:00.0: Phy6 : No sig fis
[21055.460022] mvsas 0000:04:00.0: Phy6 : No sig fis
[21055.631886] sas: sas_form_port: phy6 belongs to port5 already(1)!
[21056.420060] ata14: hard resetting link
[21056.420070] sas: sas_ata_hard_reset: Found ATA device.
[21056.486683] ata14.00: configured for UDMA/133
[21056.486708] ata14: EH complete
[21056.486718] ata15: sas eh calling libata port error handler
[21056.486735] sas: --- Exit sas_scsi_recover_host
[21056.665913] sas: sas_ata_task_done: SAS error 8a
[21056.665947] sas: Enter sas_scsi_recover_host
[21056.665958] ata14: sas eh calling libata cmd error handler
[21056.665973] ata9: sas eh calling libata port error handler
[21056.665996] ata10: sas eh calling libata port error handler
[21056.666011] ata11: sas eh calling libata port error handler
[21056.666024] ata12: sas eh calling libata port error handler
[21056.666035] ata13: sas eh calling libata port error handler
[21056.666047] ata14: sas eh calling libata port error handler
[21056.666066] sas: sas_ata_task_done: SAS error 8a
[21056.666079] ata14: failed to read log page 10h (errno=-5)
[21056.667428] ata14.00: exception Emask 0x1 SAct 0x1 SErr 0x0 action 0x6
[21056.668777] ata14.00: failed command: READ FPDMA QUEUED
[21056.670091] ata14.00: cmd 60/08:00:a8:ed:2e/00:00:10:00:00/40 tag 0 ncq 4096 in
[21056.670095]          res 01/04:00:20:59:6d/00:00:02:00:00/40 Emask 0x3 (HSM violation)
[21056.672687] ata14.00: status: { ERR }
[21056.674070] ata14.00: error: { ABRT }
[21056.675399] ata14: hard resetting link
[21056.675405] sas: sas_ata_hard_reset: Found ATA device.
[21056.675418] sas: sas_ata_task_done: SAS error 8a
[21056.675480] sas: sas_ata_task_done: SAS error 8a
[21056.675489] ata14.00: both IDENTIFYs aborted, assuming NODEV
[21056.675496] ata14.00: revalidation failed (errno=-2)
[21057.512008] mvsas 0000:04:00.0: Phy6 : No sig fis
[21058.624012] mvsas 0000:04:00.0: Phy6 : No sig fis
[21059.564016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21060.676016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21061.616006] mvsas 0000:04:00.0: Phy6 : No sig fis
[21061.672045] ata14: hard resetting link
[21061.672055] sas: sas_ata_hard_reset: Found ATA device.
[21061.672116] sas: sas_ata_task_done: SAS error 2
[21061.672193] sas: sas_ata_task_done: SAS error 2
[21061.672208] ata14.00: both IDENTIFYs aborted, assuming NODEV
[21061.672216] ata14.00: revalidation failed (errno=-2)
[21062.728006] mvsas 0000:04:00.0: Phy6 : No sig fis
[21064.324014] mvsas 0000:04:00.0: Phy6 : No sig fis
[21064.780018] mvsas 0000:04:00.0: Phy6 : No sig fis
[21066.376015] mvsas 0000:04:00.0: Phy6 : No sig fis
[21066.672061] ata14: hard resetting link
[21066.672070] sas: sas_ata_hard_reset: Found ATA device.
[21066.672124] sas: sas_ata_task_done: SAS error 2
[21066.672168] sas: sas_ata_task_done: SAS error 2
[21066.672183] ata14.00: both IDENTIFYs aborted, assuming NODEV
[21066.672190] ata14.00: revalidation failed (errno=-2)
[21066.673517] ata14.00: disabled
[21066.673542] ata14: EH complete
[21066.673550] ata15: sas eh calling libata port error handler
[21066.673570] sas: --- Exit sas_scsi_recover_host
[21066.673690] sd 8:0:5:0: [sdi] Unhandled error code
[21066.673697] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[21066.673707] sd 8:0:5:0: [sdi] CDB: Read(10): 28 00 10 2e ed a8 00 00 08 00
[21066.673738] end_request: I/O error, dev sdi, sector 271510952
[21066.679965] sd 8:0:5:0: [sdi] Unhandled error code
[21066.679971] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[21066.679979] sd 8:0:5:0: [sdi] CDB: Write(10): 2a 00 00 00 00 02 00 00 05 00
[21066.679997] end_request: I/O error, dev sdi, sector 2
[21066.686083] end_request: I/O error, dev sdi, sector 2
[21066.690044] md: super_written gets error=-5, uptodate=0
[21066.690044] md/raid:md1: Disk failure on sdi, disabling device.
[21066.690044] md/raid:md1: Operation continuing on 6 devices.
[21066.742358] RAID conf printout:
[21066.742361]  --- level:5 rd:7 wd:6
[21066.742363]  disk 0, o:1, dev:sdf
[21066.742364]  disk 1, o:1, dev:sdg
[21066.742366]  disk 2, o:1, dev:sdd
[21066.742367]  disk 3, o:1, dev:sde
[21066.742369]  disk 4, o:1, dev:sdj
[21066.742370]  disk 5, o:0, dev:sdi
[21066.742371]  disk 6, o:1, dev:sdh
[21066.745218] RAID conf printout:
[21066.745227]  --- level:5 rd:7 wd:6
[21066.745234]  disk 0, o:1, dev:sdf
[21066.745240]  disk 1, o:1, dev:sdg
[21066.745245]  disk 2, o:1, dev:sdd
[21066.745249]  disk 3, o:1, dev:sde
[21066.745264]  disk 4, o:1, dev:sdj
[21066.745269]  disk 6, o:1, dev:sdh
[21066.832016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21068.428013] mvsas 0000:04:00.0: Phy6 : No sig fis
[21068.895664] mvsas 0000:04:00.0: Phy6 : No sig fis
[21070.480008] mvsas 0000:04:00.0: Phy6 : No sig fis
[21070.936016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21072.532018] mvsas 0000:04:00.0: Phy6 : No sig fis
[21072.988016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21074.584017] mvsas 0000:04:00.0: Phy6 : No sig fis
[21075.040016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21076.636009] mvsas 0000:04:00.0: Phy6 : No sig fis
[21077.092020] mvsas 0000:04:00.0: Phy6 : No sig fis
[21077.886806] sas: sas_form_port: phy6 belongs to port5 already(1)!
[21098.260007] mvsas 0000:04:00.0: Phy6 : No sig fis
[21100.312016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21100.512833] sas: sas_form_port: phy6 belongs to port5 already(1)!
[21119.388007] mvsas 0000:04:00.0: Phy6 : No sig fis
[21121.472339] sd 8:0:5:0: [sdi] Synchronizing SCSI cache
[21121.472460] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[21121.472474] sd 8:0:5:0: [sdi] Stopping disk
[21121.472512] sd 8:0:5:0: [sdi] START_STOP FAILED
[21121.472521] sd 8:0:5:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[21124.632016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21133.336022] mvsas 0000:04:00.0: Phy6 : No sig fis
[21135.424511] mvsas 0000:04:00.0: Phy6 : No sig fis
[21137.440016] mvsas 0000:04:00.0: Phy6 : No sig fis
[21138.137603] sas: phy-8:6 added to port-8:5, phy_mask:0x40 ( 600000000000000)
[21138.137636] sas: DOING DISCOVERY on port 5, pid:235
[21138.140579] sas: Enter sas_scsi_recover_host
[21138.140584] ata9: sas eh calling libata port error handler
[21138.140595] ata10: sas eh calling libata port error handler
[21138.140600] ata11: sas eh calling libata port error handler
[21138.140605] ata12: sas eh calling libata port error handler
[21138.140609] ata13: sas eh calling libata port error handler
[21138.140614] ata15: sas eh calling libata port error handler
[21138.140619] ata16: sas eh calling libata port error handler
[21138.140627] sas: sas_ata_hard_reset: Found ATA device.
[21138.167643] ata16.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[21138.167649] ata16.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[21138.207197] ata16.00: configured for UDMA/133
[21138.207217] sas: --- Exit sas_scsi_recover_host
[21138.207436] scsi 8:0:7:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[21138.207899] sd 8:0:7:0: Attached scsi generic sg8 type 0
[21138.208030] sd 8:0:7:0: [sdk] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[21138.208220] sd 8:0:7:0: [sdk] Write Protect is off
[21138.208229] sd 8:0:7:0: [sdk] Mode Sense: 00 3a 00 00
[21138.208281] sd 8:0:7:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[21138.208380] sas: DONE DISCOVERY on port 5, pid:235, result:0
[21138.225975]  sdk: unknown partition table
[21138.226482] sd 8:0:7:0: [sdk] Attached SCSI disk
[72609.206763] sd 8:0:7:0: [sdk] Synchronizing SCSI cache
[72609.206890] sd 8:0:7:0: [sdk]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[72609.206904] sd 8:0:7:0: [sdk] Stopping disk
[72609.206935] sd 8:0:7:0: [sdk] START_STOP FAILED
[72609.206941] sd 8:0:7:0: [sdk]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[72612.720016] mvsas 0000:04:00.0: Phy6 : No sig fis
[72614.772017] mvsas 0000:04:00.0: Phy6 : No sig fis
[72616.824016] mvsas 0000:04:00.0: Phy6 : No sig fis
[72618.876020] mvsas 0000:04:00.0: Phy6 : No sig fis
[72620.064059] sas: phy-8:6 added to port-8:5, phy_mask:0x40 ( 600000000000000)
[72620.064569] sas: DOING DISCOVERY on port 5, pid:227
[72620.067073] sas: Enter sas_scsi_recover_host
[72620.067083] ata9: sas eh calling libata port error handler
[72620.067105] ata10: sas eh calling libata port error handler
[72620.067120] ata11: sas eh calling libata port error handler
[72620.067133] ata12: sas eh calling libata port error handler
[72620.067144] ata13: sas eh calling libata port error handler
[72620.067157] ata15: sas eh calling libata port error handler
[72620.067168] ata17: sas eh calling libata port error handler
[72620.067180] sas: sas_ata_hard_reset: Found ATA device.
[72620.094238] ata17.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[72620.094249] ata17.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[72620.133748] ata17.00: configured for UDMA/133
[72620.133770] sas: --- Exit sas_scsi_recover_host
[72620.133922] scsi 8:0:8:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[72620.134411] sd 8:0:8:0: [sdk] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[72620.134423] sd 8:0:8:0: Attached scsi generic sg8 type 0
[72620.134596] sas: DONE DISCOVERY on port 5, pid:227, result:0
[72620.134655] sd 8:0:8:0: [sdk] Write Protect is off
[72620.134664] sd 8:0:8:0: [sdk] Mode Sense: 00 3a 00 00
[72620.134754] sd 8:0:8:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[72620.152891]  sdk: unknown partition table
[72620.153465] sd 8:0:8:0: [sdk] Attached SCSI disk
[76711.440019] mvsas 0000:04:00.0: Phy6 : No sig fis
[76713.492006] mvsas 0000:04:00.0: Phy6 : No sig fis
[76715.544016] mvsas 0000:04:00.0: Phy6 : No sig fis
[76717.599362] mvsas 0000:04:00.0: Phy6 : No sig fis
[76719.648015] mvsas 0000:04:00.0: Phy6 : No sig fis
[76721.700012] mvsas 0000:04:00.0: Phy6 : No sig fis
[76722.598654] sas: sas_form_port: phy6 belongs to port5 already(1)!
[76725.900016] mvsas 0000:04:00.0: Phy6 : No sig fis
[76727.952017] mvsas 0000:04:00.0: Phy6 : No sig fis
[76728.103256] sas: sas_form_port: phy6 belongs to port5 already(1)!

So, it seems to have at least recovered this time, rather than locking up,
unfortunately now my raid5 array is rebuilding. Thankfully it seems to have
been able to use the mdraid bitmap feature, as it only took 20 minutes.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
