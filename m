Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2KNDyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:54:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab2KNDyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:54:22 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=T6LLiOXh6RwA:10 a=6m4_6qrbAAAA:8 a=FP58Ms26AAAA:8 a=tnNUVOCqO-Sv9Muq8XIA:9 a=PUjeQqilurYA:10 a=is1_aGvINgzKpvDK:21 a=OD-SAHh6M3Yzi18H:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352865261.18025.61.camel@gandalf.local.home>
Subject: Possible disk failure
From: Steven Rostedt <rostedt@goodmis.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Nov 2012 22:54:21 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Since you helped me out before, I'm going to ask for some more help ;-)

I just recently purchased a new workstation from HP, and after fighting
with getting grub2 working the way I want, I kicked off a ktest run to
create a true min config. It basically disables options from the .config
file until it finds a .config that that boots but will fail if you
disable any of the configs that are set.

Anyway, in the middle of this test, I started getting these nasty ata
errors again (like the ones I got with the failed HD that you helped me
out with on G+). But this is a brand new spanking machine (with a new
HD), but I could have gotten a lemon.

Anyway, the full dmesg is at:

http://rostedt.homelinux.com/private/bxtest-ata-fail-dmesg

And here's a smartctl dump:

[root@bxtest ~]# smartctl --all /dev/sda
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-3.5.5-custom] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Blue Serial ATA
Device Model:     WDC WD5000AAKX-60U6AA0
Serial Number:    WD-WCC2EF801545
LU WWN Device Id: 5 0014ee 25ccb70a0
Firmware Version: 18.01H18
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Tue Nov 13 17:48:40 2012 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (  40)	The self-test routine was interrupted
					by the host with a hard or soft reset.
Total time to complete Offline 
data collection: 		( 7860) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  80) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       78
  3 Spin_Up_Time            0x0027   143   142   021    Pre-fail  Always       -       3850
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       138
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002f   100   253   051    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       43
 10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       136
184 End-to-End_Error        0x0033   100   100   097    Pre-fail  Always       -       0
187 Reported_Uncorrect      0x0032   022   022   000    Old_age   Always       -       78
188 Command_Timeout         0x0032   094   094   000    Old_age   Always       -       6
190 Airflow_Temperature_Cel 0x0022   074   067   040    Old_age   Always       -       26 (Min/Max 26/27)
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       123
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       14
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       1
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      80%         1         -

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

[root@bxtest ~]# 


Any help would be appreciated. Is this HD a lemon (need to return it?)
or did something else go wrong that is fixable.

Thanks!

-- Steve

