Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978Ab2KNFHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:07:15 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53174 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2KNFHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:07:13 -0500
Message-ID: <50A326FF.6060502@gmail.com>
Date: Tue, 13 Nov 2012 23:07:11 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible disk failure
References: <1352865261.18025.61.camel@gandalf.local.home>
In-Reply-To: <1352865261.18025.61.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 09:54 PM, Steven Rostedt wrote:
> Hi Jens,
>
> Since you helped me out before, I'm going to ask for some more help ;-)
>
> I just recently purchased a new workstation from HP, and after fighting
> with getting grub2 working the way I want, I kicked off a ktest run to
> create a true min config. It basically disables options from the .config
> file until it finds a .config that that boots but will fail if you
> disable any of the configs that are set.
>
> Anyway, in the middle of this test, I started getting these nasty ata
> errors again (like the ones I got with the failed HD that you helped me
> out with on G+). But this is a brand new spanking machine (with a new
> HD), but I could have gotten a lemon.
>
> Anyway, the full dmesg is at:
>
> http://rostedt.homelinux.com/private/bxtest-ata-fail-dmesg

The important part being:

[   11.974811] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[   11.982816] ata1.00: irq_stat 0x40000008
[   11.987512] ata1.00: failed command: READ FPDMA QUEUED
[   11.993407] ata1.00: cmd 60/08:00:00:20:92/00:00:07:00:00/40 tag 0 
ncq 4096 in
[   11.993407]          res 41/40:00:04:20:92/00:00:07:00:00/40 Emask 
0x409 (media error) <F>
[   12.010367] ata1.00: status: { DRDY ERR }
[   12.015146] ata1.00: error: { UNC }

..

[   16.527065] end_request: I/O error, dev sda, sector 127016964

i.e. the drive reported an uncorrected read error on sector 127016964.

>
> And here's a smartctl dump:
>
> [root@bxtest ~]# smartctl --all /dev/sda
> smartctl 5.43 2012-06-30 r3573 [x86_64-linux-3.5.5-custom] (local build)
> Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net
>
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Caviar Blue Serial ATA
> Device Model:     WDC WD5000AAKX-60U6AA0
> Serial Number:    WD-WCC2EF801545
> LU WWN Device Id: 5 0014ee 25ccb70a0
> Firmware Version: 18.01H18
> User Capacity:    500,107,862,016 bytes [500 GB]
> Sector Size:      512 bytes logical/physical
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   8
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Tue Nov 13 17:48:40 2012 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
>
> General SMART Values:
> Offline data collection status:  (0x80)	Offline data collection activity
> 					was never started.
> 					Auto Offline Data Collection: Enabled.
> Self-test execution status:      (  40)	The self-test routine was interrupted
> 					by the host with a hard or soft reset.
> Total time to complete Offline
> data collection: 		( 7860) seconds.
> Offline data collection
> capabilities: 			 (0x5b) SMART execute Offline immediate.
> 					Auto Offline data collection on/off support.
> 					Suspend Offline collection upon new
> 					command.
> 					Offline surface scan supported.
> 					Self-test supported.
> 					No Conveyance Self-test supported.
> 					Selective Self-test supported.
> SMART capabilities:            (0x0003)	Saves SMART data before entering
> 					power-saving mode.
> 					Supports SMART auto save timer.
> Error logging capability:        (0x01)	Error logging supported.
> 					General Purpose Logging supported.
> Short self-test routine
> recommended polling time: 	 (   2) minutes.
> Extended self-test routine
> recommended polling time: 	 (  80) minutes.
> SCT capabilities: 	       (0x303f)	SCT Status supported.
> 					SCT Error Recovery Control supported.
> 					SCT Feature Control supported.
> 					SCT Data Table supported.
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       78
>    3 Spin_Up_Time            0x0027   143   142   021    Pre-fail  Always       -       3850
>    4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       138
>    5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
>    7 Seek_Error_Rate         0x002f   100   253   051    Pre-fail  Always       -       0
>    9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       43
>   10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail  Always       -       0
>   11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
>   12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       136
> 184 End-to-End_Error        0x0033   100   100   097    Pre-fail  Always       -       0
> 187 Reported_Uncorrect      0x0032   022   022   000    Old_age   Always       -       78
> 188 Command_Timeout         0x0032   094   094   000    Old_age   Always       -       6
> 190 Airflow_Temperature_Cel 0x0022   074   067   040    Old_age   Always       -       26 (Min/Max 26/27)
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       123
> 193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       14
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       1

So it looks like the drive reports there's 1 sector that will be 
reallocated once it gets rewritten. It could be that the drive is 
actually OK but that sector just got mis-written (due to a hard 
power-off while it was being written, perhaps) and will be fine once it 
gets written successfully.

You could try using hdparm commands to overwrite that sector, or just 
boot from a live CD, zero out the entire disk with "dd if=/dev/zero 
of=/dev/sda" and try a reinstall. If the drives go away and a long SMART 
self test reports no errors, the drive is likely OK. If not, a 
replacement is likely in order.

> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offline      -       0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Interrupted (host reset)      80%         1         -
>
> SMART Selective self-test log data structure revision number 1
>   SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>      1        0        0  Not_testing
>      2        0        0  Not_testing
>      3        0        0  Not_testing
>      4        0        0  Not_testing
>      5        0        0  Not_testing
> Selective self-test flags (0x0):
>    After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
>
> [root@bxtest ~]#
>
>
> Any help would be appreciated. Is this HD a lemon (need to return it?)
> or did something else go wrong that is fixable.
>
> Thanks!
>
> -- Steve
>

