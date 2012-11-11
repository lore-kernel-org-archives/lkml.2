Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab2KKH5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 02:57:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2KKH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 02:57:11 -0500
From: "Michael D. Setzer II" <msetzerii@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Sun, 11 Nov 2012 17:57:07 +1000
MIME-Version: 1.0
Subject: Kernel Firmware - Adding Right way??
Message-ID: <509F5A53.26612.2D87FF@msetzerii.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been the maintainer of the g4l project since about 2004, and 
have had issues with a few users that have hardware that requires 
firmware that isn't included in the kernel.org kernel.

I want to do this the right way, since this is what it shows in the 
kernel firmware directory.


	DO NOT ADD FIRMWARE TO THIS DIRECTORY.
	======================================

This directory is only here to contain firmware images extracted 
from old device drivers which predate the common use of 
request_firmware().

Problem is that when I manually add the missing firmware to the 
firmware directory, and add it to the list in the Makefile it works 
just fine, but I then tried to add the new firmware file directory to 
the cd it doesn't find the firmware.

User reports this in dmesg.

firmware 0000:04:00.0: firmware: requesting 
bnx2x/bnx2x-e2-7.2.51.0.fw
PM: Removing info for No Bus:0000:04:00.0
bnx2x: bnx2x_init_firmware:11647(eth0)Can't load firmware file 
bnx2x/bnx2x-e2-7.2.51.0.fw
bnx2x: bnx2x_func_hw_init:5477(eth0)Error loading firmware
bnx2x: bnx2x_nic_load:2136(eth0)HW init failed, aborting

The firmware is download using
 
git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.
git

and files and subdirectories are placed in the /lib/firmware 
directory except for the .git directory.

So, not sure why it isn't finding the the kernel files.

The options involving FIRMWARE are currently
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_HOSTAP_FIRMWARE is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_GOOGLE_FIRMWARE is not set

The project builds all options in the kernel instead of using 
moduals since it includes a number of kernels to support various 
hardware and has most nics and disk adapters selected. 

link to the latest config file.

ftp://amd64gcc.dyndns.org/bz3x6.6.config

I've search over the web, and have even been communicating 
with the maintainer of the bnx2x firmware that is the issue.

I'm hoping it is just some simple setting or option that needs to be 
set. Adding the 40M of firmware required increasing the ramdisk 
size for 64M to 128M to make room, but would like to have the 
firmware available for users that might need it to have the project 
work on there hardware. 

Thanks.




+----------------------------------------------------------+
  Michael D. Setzer II -  Computer Science Instructor      
  Guam Community College  Computer Center                  
  mailto:mikes@kuentos.guam.net                            
  mailto:msetzerii@gmail.com
  http://www.guam.net/home/mikes
  Guam - Where America's Day Begins                        
  G4L Disk Imaging Project maintainer 
  http://sourceforge.net/projects/g4l/
+----------------------------------------------------------+

http://setiathome.berkeley.edu (Original)
Number of Seti Units Returned:  19,471
Processing time:  32 years, 290 days, 12 hours, 58 minutes
(Total Hours: 287,489)

BOINC@HOME CREDITS
SETI        13233290.532525   |   EINSTEIN     9012033.029852
ROSETTA      5329761.808862   |   ABC         15417521.047462

