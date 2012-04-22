Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab2DVKV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 06:21:26 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1975 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899Ab2DVKVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 06:21:25 -0400
Message-ID: <1335090082.1814.27.camel@x61.thuisdomein>
Subject: arch/arm/mach-s3c2410/Kconfig is unsourced
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Apr 2012 12:21:22 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Apr 2012 10:21:22.0915 (UTC) FILETIME=[AA98DB30:01CD2071]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) commit 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
mach-s3c2410/* into mach-s3c24xx/") orphaned
arch/arm/mach-s3c2410/Kconfig: currently nothing sources that file in
Linus' tree.

1) I haven't looked in depth at this, but this made S3C2410_PLLTABLE
disappear from the build system (ie, arch/arm/mach-s3c2410/pll.c is dead
code now). Moreover, this basically turned both "select S3C2410_CPUFREQ
if CPU_FREQ_S3C24XX", under "config CPU_S3C2410", and "select
S3C2410_IOTIMING if S3C2410_CPUFREQ", under "config ARCH_BAST", into
nops (both in arch/arm/mach-s3c24xx/Kconfig).

2) So to me it seems the move has only been done half: either more
things needs to be moved or those things can be removed entirely. But
perhaps arch/arm/mach-s3c2410/Kconfig should just be sourced again.


Paul Bolle

