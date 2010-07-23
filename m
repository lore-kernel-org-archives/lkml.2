Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0GWOpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:45:35 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:47701 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab0GWOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:45:14 -0400
Date: Fri, 23 Jul 2010 10:45:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: latest scan for "bad" config variable references in kernel tree
Message-ID: <alpine.DEB.2.00.1007231040330.958@lynx>
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


  as of 2.6.35-rc6, i ran another scan of the tree, looking for "bad"
config variable references, as in, preprocessor tests of CONFIG_
variables that aren't defined in any Kconfig file that i can see.

  it's all broken down by directory and subdirectory:

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

  as an example, here's what showed up under drivers/mmc:

>>>>> MMC_EMBEDDED_SDIO
drivers/mmc/host/msm_sdcc.c:1148:#ifdef CONFIG_MMC_EMBEDDED_SDIO
>>>>> MMC_MSM7X00A_RESUME_IN_WQ
drivers/mmc/host/msm_sdcc.h:238:#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ
drivers/mmc/host/msm_sdcc.c:1060:#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ

  as in, there's a test for "CONFIG_MMC_EMBEDDED_SDIO" when there is
no definition of such a variable in a Kconfig file.

  more scanning coming later, but that page covers the whole tree
looking for just that property.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
