Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab2DKVHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:07:40 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:42919 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761242Ab2DKVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:07:37 -0400
Date: Wed, 11 Apr 2012 17:07:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: almost time to run my kernel source cleaning scripts again?
Message-ID: <alpine.DEB.2.02.1204111700170.4733@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  it's been a while so i was thinking of firing up my scripts to
peruse the source tree looking for oddities/inconsistencies/whatever
(unless someone else is already doing that).

  one example is looking for preprocessor tests of symbols that aren't
defined in any Kconfig file, and i can focus on any part of the source
tree.  for example, if i run that script against drivers/mmc, i get:

>>>>> MMC_MSM7X00A_RESUME_IN_WQ
drivers/mmc/host/msm_sdcc.c:1408:#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ

telling me that a source file is testing a CONFIG variable that
doesn't exist.

  the scripts are available online (maybe i better test them first),
so anyone's free to run them against any part of the tree they want.

  running this script against drivers/staging is always good for
entertainment:

>>>>> CAVIUM_OCTEON_NUM_PACKET_BUFFERS
drivers/staging/octeon/ethernet-defines.h:36: *  CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS
drivers/staging/octeon/ethernet.c:56:#if defined(CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS) \
drivers/staging/octeon/ethernet.c:57:	&& CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS
drivers/staging/octeon/ethernet.c:58:int num_packet_buffers = CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS;
>>>>> CONSOLE_115200
drivers/staging/serial/68360serial.c:310:#elif defined(CONFIG_CONSOLE_115200)
>>>>> CONSOLE_19200
drivers/staging/serial/68360serial.c:308:#elif defined(CONFIG_CONSOLE_19200)
>>>>> CONSOLE_9600
drivers/staging/serial/68360serial.c:306:#if defined(CONFIG_CONSOLE_9600)
>>>>> FORCE_HARD_FLOAT
drivers/staging/rtl8192u/r8192U_core.c:27:#ifndef CONFIG_FORCE_HARD_FLOAT
... lots more ...

  i'll make sure the scripts work and maybe let them loose to find
stuff in a day or two.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
