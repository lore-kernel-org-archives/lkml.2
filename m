Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0FVGYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:24:19 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60592 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab0FVGYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:24:18 -0400
Date: Tue, 22 Jun 2010 02:24:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Simplify conditional processing of fs/proc.o.
Message-ID: <alpine.DEB.2.00.1006220218310.13501@lynx>
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


Since the entire fs/proc directory is conditionally included based on
CONFIG_PROC_FS, it's redundant to check that same variable within that
directory.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 11a7b5c..2758e2a 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux proc filesystem routines.
 #

-obj-$(CONFIG_PROC_FS) += proc.o
+obj-y   += proc.o

 proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o


rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
