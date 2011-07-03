Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab1GCKvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 06:51:00 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42745 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab1GCKuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 06:50:55 -0400
Message-ID: <4E104989.6070702@gmail.com>
Date: Sun, 03 Jul 2011 13:50:49 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SATA EH reset renames device (caused by smart self-tests?)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this SATA EH reset on a disk part of RAID, and after recovery it got renamed
from /dev/sdd to /dev/sdj.  Would've been good if the original name was kept, as it'd have been easier to readd.
See below for the SATA link reset messages.
Don't know what that SError is, I've run a SMART short self-test and everything was good, no errors logged.

While running smartctl -t short I noticed another EH reset though, so could it be that these EH resets
occur when the drive is a bit busy with running its automatic SMART self-tests?

[    0.000000] Linux version 3.0.0-rc5 (edwin@debian) (gcc version 4.6.1 20110616 (prerelease) (Debian 4.6.0-14) ) #155 SMP PREEMPT Tue Jun 28 16:58:38 EEST 2011
[...]
Jul  3 10:21:56 debian kernel: [    0.874957] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 44
Jul  3 10:21:56 debian kernel: [    1.335122] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul  3 10:21:56 debian kernel: [    1.345877] ata4.00: HPA detected: current 1465147055, native 1465149168
Jul  3 10:21:56 debian kernel: [    1.345947] ata4.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
Jul  3 10:21:56 debian kernel: [    1.345949] ata4.00: 1465147055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Jul  3 10:21:56 debian kernel: [    1.346935] ata4.00: configured for UDMA/133
Jul  3 10:21:56 debian kernel: [    1.347033] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
Jul  3 10:21:56 debian kernel: [    1.347255] sd 3:0:0:0: [sdd] 1465147055 512-byte logical blocks: (750 GB/698 GiB)
Jul  3 10:21:56 debian kernel: [    1.347325] sd 3:0:0:0: [sdd] Write Protect is off
Jul  3 10:21:56 debian kernel: [    1.347328] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Jul  3 10:21:56 debian kernel: [    1.347359] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[...]
Jul  3 10:21:59 debian smartd[2793]: Device: /dev/sdd [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 113 to 124
Jul  3 10:21:59 debian smartd[2793]: Device: /dev/sdd [SAT], offline data collection was suspended by an interrupting command from host (auto:on)
[...]
Jul  3 11:00:32 debian kernel: [ 2329.109193] ata4.00: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
Jul  3 11:00:32 debian kernel: [ 2329.109203] ata4.00: irq_stat 0x00400000, PHY RDY changed
Jul  3 11:00:32 debian kernel: [ 2329.109212] ata4: SError: { RecovComm Persist PHYRdyChg 10B8B }
Jul  3 11:00:32 debian kernel: [ 2329.109218] ata4.00: failed command: FLUSH CACHE EXT
Jul  3 11:00:32 debian kernel: [ 2329.109232] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Jul  3 11:00:32 debian kernel: [ 2329.109235]          res 40/00:04:08:08:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
Jul  3 11:00:32 debian kernel: [ 2329.109241] ata4.00: status: { DRDY }
Jul  3 11:00:32 debian kernel: [ 2329.109251] ata4: hard resetting link
Jul  3 11:00:37 debian kernel: [ 2334.679069] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul  3 11:00:37 debian kernel: [ 2334.707359] ata4.00: configured for UDMA/133
Jul  3 11:00:37 debian kernel: [ 2334.707369] ata4.00: retrying FLUSH 0xea Emask 0x10
Jul  3 11:00:37 debian kernel: [ 2334.718108] ata4: EH complete
Jul  3 11:42:44 debian kernel: [ 4861.650243] ata4: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
Jul  3 11:42:44 debian kernel: [ 4861.650253] ata4: irq_stat 0x00400000, PHY RDY changed
Jul  3 11:42:44 debian kernel: [ 4861.650262] ata4: SError: { RecovComm Persist PHYRdyChg 10B8B }
Jul  3 11:42:44 debian kernel: [ 4861.650273] ata4: hard resetting link
Jul  3 11:42:44 debian kernel: [ 4861.650299] ata5: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
Jul  3 11:42:44 debian kernel: [ 4861.650304] ata5: irq_stat 0x00400000, PHY RDY changed
Jul  3 11:42:44 debian kernel: [ 4861.650310] ata5: SError: { RecovComm Persist PHYRdyChg 10B8B }
Jul  3 11:42:44 debian kernel: [ 4861.650317] ata5: hard resetting link
Jul  3 11:42:45 debian kernel: [ 4862.577063] ata4: SATA link down (SStatus 0 SControl 300)
Jul  3 11:42:45 debian kernel: [ 4862.626969] ata4: hard resetting link
Jul  3 11:42:45 debian kernel: [ 4862.627061] ata5: SATA link down (SStatus 0 SControl 300)
Jul  3 11:42:45 debian kernel: [ 4862.627471] ata5: hard resetting link
Jul  3 11:42:51 debian kernel: [ 4868.546117] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul  3 11:42:51 debian kernel: [ 4868.573221] ata4.00: configured for UDMA/133
Jul  3 11:42:51 debian kernel: [ 4868.584107] ata4: EH complete
Jul  3 11:42:52 debian kernel: [ 4869.260122] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul  3 11:42:52 debian kernel: [ 4869.288156] ata5.00: configured for UDMA/133
Jul  3 11:42:52 debian kernel: [ 4869.299043] ata5: EH complete
Jul  3 12:05:33 debian kernel: [ 6230.389292] ata4: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
Jul  3 12:05:33 debian kernel: [ 6230.389301] ata4: irq_stat 0x00400000, PHY RDY changed
Jul  3 12:05:33 debian kernel: [ 6230.389309] ata4: SError: { RecovComm Persist PHYRdyChg 10B8B }
Jul  3 12:05:33 debian kernel: [ 6230.389320] ata4: hard resetting link
Jul  3 12:05:33 debian kernel: [ 6230.389344] ata5: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
Jul  3 12:05:33 debian kernel: [ 6230.389349] ata5: irq_stat 0x00400000, PHY RDY changed
Jul  3 12:05:33 debian kernel: [ 6230.389355] ata5: SError: { RecovComm Persist PHYRdyChg 10B8B }
Jul  3 12:05:33 debian kernel: [ 6230.389362] ata5: hard resetting link
Jul  3 12:05:34 debian kernel: [ 6231.316128] ata4: SATA link down (SStatus 0 SControl 300)
Jul  3 12:05:34 debian kernel: [ 6231.353734] ata4: hard resetting link
Jul  3 12:05:35 debian kernel: [ 6232.117074] ata4: SATA link down (SStatus 0 SControl 300)
Jul  3 12:05:35 debian kernel: [ 6232.117091] ata4: limiting SATA link speed to 1.5 Gbps
Jul  3 12:05:35 debian kernel: [ 6232.129202] ata4: hard resetting link
Jul  3 12:05:35 debian kernel: [ 6232.893129] ata4: SATA link down (SStatus 0 SControl 310)
Jul  3 12:05:35 debian kernel: [ 6232.893144] ata4.00: disabled
Jul  3 12:05:35 debian kernel: [ 6232.904110] ata4: exception Emask 0x10 SAct 0x0 SErr 0x40c0002 action 0xe frozen t4
Jul  3 12:05:35 debian kernel: [ 6232.904119] ata4: irq_stat 0x00000040, connection status changed
Jul  3 12:05:35 debian kernel: [ 6232.904127] ata4: SError: { RecovComm CommWake 10B8B DevExch }
Jul  3 12:05:35 debian kernel: [ 6232.904137] ata4: limiting SATA link speed to 1.5 Gbps
Jul  3 12:05:35 debian kernel: [ 6232.904144] ata4: hard resetting link
Jul  3 12:05:36 debian kernel: [ 6233.061194] sd 3:0:0:0: rejecting I/O to offline device
Jul  3 12:05:36 debian kernel: [ 6233.061205] end_request: I/O error, dev sdd, sector 2056
Jul  3 12:05:36 debian kernel: [ 6233.061214] md: super_written gets error=-5, uptodate=0
Jul  3 12:05:36 debian kernel: [ 6233.061222] md/raid10:md1: Disk failure on sdd1, disabling device.
Jul  3 12:05:36 debian kernel: [ 6233.061225] md/raid10:md1: Operation continuing on 5 devices.
Jul  3 12:05:37 debian kernel: [ 6234.403110] ata4: SATA link down (SStatus 0 SControl 310)
Jul  3 12:05:37 debian kernel: [ 6234.414097] ata4: EH complete
Jul  3 12:05:37 debian kernel: [ 6234.414123] ata4.00: detaching (SCSI 3:0:0:0)
Jul  3 12:05:37 debian kernel: [ 6234.431279] sd 3:0:0:0: [sdd] Synchronizing SCSI cache
Jul  3 12:05:37 debian kernel: [ 6234.431354] sd 3:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jul  3 12:05:37 debian kernel: [ 6234.431363] sd 3:0:0:0: [sdd] Stopping disk
Jul  3 12:05:37 debian kernel: [ 6234.431382] sd 3:0:0:0: [sdd] START_STOP FAILED
Jul  3 12:05:37 debian kernel: [ 6234.431386] sd 3:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jul  3 12:05:37 debian kernel: [ 6234.455539] ata4: exception Emask 0x10 SAct 0x0 SErr 0x40d0002 action 0xe frozen
Jul  3 12:05:37 debian kernel: [ 6234.455548] ata4: irq_stat 0x00000040, connection status changed
Jul  3 12:05:37 debian kernel: [ 6234.455556] ata4: SError: { RecovComm PHYRdyChg CommWake 10B8B DevExch }
Jul  3 12:05:37 debian kernel: [ 6234.455567] ata4: limiting SATA link speed to 1.5 Gbps
Jul  3 12:05:37 debian kernel: [ 6234.455574] ata4: hard resetting link
Jul  3 12:05:38 debian kernel: [ 6235.981115] ata4: SATA link down (SStatus 0 SControl 310)
Jul  3 12:05:38 debian kernel: [ 6235.992086] ata4: EH complete
Jul  3 12:05:39 debian kernel: [ 6236.009992] ata4: exception Emask 0x10 SAct 0x0 SErr 0x40c0000 action 0xe frozen
Jul  3 12:05:39 debian kernel: [ 6236.010000] ata4: irq_stat 0x00000040, connection status changed
Jul  3 12:05:39 debian kernel: [ 6236.010027] ata4: SError: { CommWake 10B8B DevExch }
Jul  3 12:05:39 debian kernel: [ 6236.010039] ata4: limiting SATA link speed to 1.5 Gbps
Jul  3 12:05:39 debian kernel: [ 6236.010047] ata4: hard resetting link
Jul  3 12:05:39 debian kernel: [ 6236.679097] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul  3 12:05:39 debian kernel: [ 6236.705743] ata5.00: configured for UDMA/133
Jul  3 12:05:39 debian kernel: [ 6236.716104] ata5: EH complete
Jul  3 12:05:39 debian kernel: [ 6236.739142] RAID10 conf printout:
Jul  3 12:05:39 debian kernel: [ 6236.739150]  --- wd:5 rd:6
Jul  3 12:05:39 debian kernel: [ 6236.739156]  disk 0, wo:0, o:1, dev:sda1
Jul  3 12:05:39 debian kernel: [ 6236.739162]  disk 1, wo:0, o:1, dev:sdb1
Jul  3 12:05:39 debian kernel: [ 6236.739167]  disk 2, wo:0, o:1, dev:sdc1
Jul  3 12:05:39 debian kernel: [ 6236.739171]  disk 3, wo:1, o:0, dev:sdd1
Jul  3 12:05:39 debian kernel: [ 6236.739176]  disk 4, wo:0, o:1, dev:sde1
Jul  3 12:05:39 debian kernel: [ 6236.739180]  disk 5, wo:0, o:1, dev:sdf1
Jul  3 12:05:39 debian kernel: [ 6236.748085] RAID10 conf printout:
Jul  3 12:05:39 debian kernel: [ 6236.748092]  --- wd:5 rd:6
Jul  3 12:05:39 debian kernel: [ 6236.748098]  disk 0, wo:0, o:1, dev:sda1
Jul  3 12:05:39 debian kernel: [ 6236.748102]  disk 1, wo:0, o:1, dev:sdb1
Jul  3 12:05:39 debian kernel: [ 6236.748107]  disk 2, wo:0, o:1, dev:sdc1
Jul  3 12:05:39 debian kernel: [ 6236.748111]  disk 4, wo:0, o:1, dev:sde1
Jul  3 12:05:39 debian kernel: [ 6236.748115]  disk 5, wo:0, o:1, dev:sdf1
Jul  3 12:05:39 debian mdadm[2820]: Fail event detected on md device /dev/md1, component device /dev/sdd1
Jul  3 12:05:47 debian kernel: [ 6244.754115] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Jul  3 12:05:47 debian kernel: [ 6244.778456] ata4.00: HPA detected: current 1465147055, native 1465149168
Jul  3 12:05:47 debian kernel: [ 6244.778543] ata4.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
Jul  3 12:05:47 debian kernel: [ 6244.778551] ata4.00: 1465147055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Jul  3 12:05:47 debian kernel: [ 6244.779579] ata4.00: configured for UDMA/133
Jul  3 12:05:47 debian kernel: [ 6244.790099] ata4: EH complete
Jul  3 12:05:47 debian kernel: [ 6244.790304] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
Jul  3 12:05:47 debian kernel: [ 6244.790655] sd 3:0:0:0: [sdj] 1465147055 512-byte logical blocks: (750 GB/698 GiB)
Jul  3 12:05:47 debian kernel: [ 6244.790949] sd 3:0:0:0: [sdj] Write Protect is off
Jul  3 12:05:47 debian kernel: [ 6244.790960] sd 3:0:0:0: [sdj] Mode Sense: 00 3a 00 00
Jul  3 12:05:47 debian kernel: [ 6244.791073] sd 3:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  3 12:05:47 debian kernel: [ 6244.816259]  sdj: sdj1 sdj2
Jul  3 12:05:47 debian kernel: [ 6244.817084] sd 3:0:0:0: [sdj] Attached SCSI disk
Jul  3 12:22:01 debian smartd[3634]: Device: /dev/sdd [SAT], open() failed: No such device
Jul  3 12:22:01 debian smartd[3634]: Sending warning via /usr/share/smartmontools/smartd-runner to root ...
Jul  3 12:22:01 debian smartd[3634]: Warning via /usr/share/smartmontools/smartd-runner to root: successfu
Jul  3 12:22:06 debian kernel: [ 7223.064686] ata4.00: exception Emask 0x10 SAct 0x0 SErr 0x10200 action 0xe frozen
Jul  3 12:22:06 debian kernel: [ 7223.064696] ata4.00: irq_stat 0x00400000, PHY RDY changed
Jul  3 12:22:06 debian kernel: [ 7223.064704] ata4: SError: { Persist PHYRdyChg }
Jul  3 12:22:06 debian kernel: [ 7223.064711] ata4.00: failed command: SMART
Jul  3 12:22:06 debian kernel: [ 7223.064724] ata4.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
Jul  3 12:22:06 debian kernel: [ 7223.064727]          res 50/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x10 (ATA bus error)
Jul  3 12:22:06 debian kernel: [ 7223.064734] ata4.00: status: { DRDY }
Jul  3 12:22:06 debian kernel: [ 7223.064743] ata4: hard resetting link
Jul  3 12:22:11 debian kernel: [ 7228.635081] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Jul  3 12:22:11 debian kernel: [ 7228.661232] ata4.00: configured for UDMA/133
Jul  3 12:22:11 debian kernel: [ 7228.672127] ata4: EH complete

Here is the SMART output for that device (/dev/sdj now):
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.0.0-rc5] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Black
Device Model:     WDC WD7501AALS-00J7B0
Serial Number:    WD-WMATV0086271
LU WWN Device Id: 5 0014ee 000b6d6c1
Firmware Version: 05.00K05
User Capacity:    750,155,292,160 bytes [750 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Jul  3 13:44:50 2011 EEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an interrupting command from host.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (  25) The self-test routine was aborted by
                                        the host.
Total time to complete Offline
data collection:                (15960) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 185) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   253   253   021    Pre-fail  Always       -       2058
  4 Start_Stop_Count        0x0032   099   099   000    Old_age   Always       -       1399
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   051    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   082   082   000    Old_age   Always       -       13503
 10 Spin_Retry_Count        0x0032   100   100   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   051    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       1394
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       61
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       1399
194 Temperature_Celsius     0x0022   112   105   000    Old_age   Always       -       38
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   051    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Aborted by host               90%     13503         -
# 2  Short offline       Completed without error       00%     13503         -
# 3  Conveyance offline  Completed without error       00%     13503         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

Note that the aborted extended offline was a smartctl -t offline followed by smartctl -X by me, long after it got kicked out of RAID,
so its not related to this issue.

Best regards,
--Edwin
