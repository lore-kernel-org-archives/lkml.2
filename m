Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0CXLuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:50:22 -0400
Received: from lucidpixels.com ([75.144.35.66]:59396 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779Ab0CXLuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:50:21 -0400
Date: Wed, 24 Mar 2010 07:50:19 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-raid@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: 2.6.33.1: RAID multi-core processing experimental option is
 broken.
Message-ID: <alpine.DEB.2.00.1003240745350.5602@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.33.1/x86_64 on an e6700 processor:

If you accidentally check [*] for Multi-core processing, the speed is
about 5MiB/s and there are some 254 processes.

When its not enabled, the speed goes back to normal and there are no longer
200-300 processes running, I have reproduced this on multiple machines now.

Enable this option in the kernel, boot the new kernel, do some raid i/o
operations/or a check/resync to the array and it will be 1/4 the speed when
multi-core processing is enabled.
   | |    [ ]       RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL| |

With it disabled, we're good:
md0 : active raid6 sdg1[5] sde1[3] sdf1[4] sdd1[2] sdc1[1] sdb1[0]
       1562834944 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       [========>............]  resync = 44.5% (173910976/390708736) finish=178.3min speed=20253K/sec

Justin.

