Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0KIMRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:17:00 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:58817 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0KIMQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:16:55 -0500
Date: Tue, 9 Nov 2010 07:16:48 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: running my kernel scanning scripts on your favourite part of the
 tree
Message-ID: <alpine.DEB.2.00.1011090711410.5783@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
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


  not sure when i'll get the time to do another pass over the kernel
source tree with my kernel cleanup scripts but anyone who's
interested is welcome to download the scripts from here:

  http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup_scripts

to check out whatever part of the tree they want.

  as a simple example, i can run the script to find "badref" config
variables on, say, the drivers/mtd part of the tree:

$ ../s/find_badref_configs.sh drivers/mtd
>>>>> MTD_SUPERH_RESERVE
drivers/mtd/maps/solutionengine.c:38:#ifdef CONFIG_MTD_SUPERH_RESERVE
drivers/mtd/maps/solutionengine.c:44:		.size = CONFIG_MTD_SUPERH_RESERVE,
drivers/mtd/maps/solutionengine.c:54:#endif /* CONFIG_MTD_SUPERH_RESERVE */
drivers/mtd/maps/solutionengine.c:97:#ifdef CONFIG_MTD_SUPERH_RESERVE
drivers/mtd/maps/solutionengine.c:100:		       CONFIG_MTD_SUPERH_RESERVE);
drivers/mtd/maps/solutionengine.c:104:#endif /* CONFIG_MTD_SUPERH_RESERVE */
$

  that tells me that, under drivers/mtd, there's some file that
insists on testing CONFIG_MTD_SUPERH_RESERVE even though no Kconfig
file defines such a variable.

  the other common check is to look for the exact opposite --
variables defined in a Kconfig file that are never tested anywhere.
once again, let's pick on drivers/mtd:

$ ../s/find_unused_configs.sh drivers/mtd
===== MTD_NAND_ATMEL_ECC_SOFT
drivers/mtd/nand/Kconfig:375:config MTD_NAND_ATMEL_ECC_SOFT
$

  that should be self-explanatory.  anyway, have at it if it interests
you.

rday


-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
