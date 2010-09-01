Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab0IABnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:43:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0IABnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:43:10 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Dan Tian <dan.tian@atheros.com>, Kevin Hayes <kevin@atheros.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Zhifeng Cai <zhifeng.cai@atheros.com>,
        Kathy Giori <kathy.giori@atheros.com>,
        Cliff Holden <cliff.holden@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Charles Marker <charles.marker@atheros.com>,
        Bernadette Yetso <bernadette.yetso@atheros.com>,
        Satagopan Kanthadai <satagopan.kanthadai@atheros.com>,
        Senthilkumar Balasubramanian 
	<senthilkumar.balasubramanian@atheros.com>
Subject: [PATCH] scripts/phb-crystal-ball: add new PHB crystal ball
Date: Tue, 31 Aug 2010 21:43:05 -0400
Message-Id: <1283305385-26478-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tired of guestimating to your bosses when you think Linus will be
releaesing the next kernel? "Its done when its done" often does not work
and often for scheduling purposes we need at least a pretty rough estimate.

This adds support for the kernel for a PHB crystal ball exactly for
this purpose. It has a PHB threshold set to 3 which cannot be modified,
otherwise we should probably panic. You can modify the number of kernels
counted to alter the average hacking days. Below are a few examples.

The first output uses the objects of from history kernel in addition to
Linus' stable kernel, since Linus' tree only keeps track of history down
to 2.6.12. Only 2.6.x kernels are currently supported.

git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Based on these estimates you can at least have a rough idea when
the 2.6.xy-rc1 would roughly be released, about 2 weeks after each release,
and can coordinate regresion testing to be scheduled around that time.

mcgrof@tux ~/wireless-testing (git::master)$ phb-crystal-ball
Kernel	            Begin-of-hacking       -     End-of-hacking   	     Hacking-day--average
v2.6.1   	2003-12-17 02:56:13 -0800  -  2004-01-08 06:57:32 -0800	             22
v2.6.2   	2004-01-08 06:57:32 -0800  -  2004-02-03 03:36:36 -0800	             26
v2.6.3   	2004-02-03 03:36:36 -0800  -  2004-02-17 03:52:37 -0800	             14
v2.6.4   	2004-02-17 03:52:37 -0800  -  2004-03-10 02:52:41 -0800	             22
v2.6.5   	2004-03-10 02:52:41 -0800  -  2004-04-03 03:34:07 -0800	             24
v2.6.6   	2004-04-03 03:34:07 -0800  -  2004-05-09 05:30:37 -0700	             36
v2.6.7   	2004-05-09 05:30:37 -0700  -  2004-06-15 08:17:47 -0700	             37
v2.6.8   	2004-06-15 08:17:47 -0700  -  2004-08-13 08:28:28 -0700	             59
v2.6.9   	2004-08-13 08:28:28 -0700  -  2004-10-17 21:50:06 -0700	             65
v2.6.10   	2004-10-17 21:50:06 -0700  -  2004-12-23 21:26:21 -0800	             67
v2.6.12   	2004-12-23 21:26:21 -0800  -  2005-06-17 12:48:29 -0700	             176
v2.6.13   	2005-06-17 12:48:29 -0700  -  2005-08-28 16:41:01 -0700	             72
v2.6.14   	2005-08-28 16:41:01 -0700  -  2005-10-27 17:02:08 -0700	             60
v2.6.15   	2005-10-27 17:02:08 -0700  -  2006-01-02 19:21:10 -0800	             67
v2.6.16   	2006-01-02 19:21:10 -0800  -  2006-03-19 21:53:29 -0800	             76
v2.6.17   	2006-03-19 21:53:29 -0800  -  2006-06-17 18:49:35 -0700	             90
v2.6.18   	2006-06-17 18:49:35 -0700  -  2006-09-19 20:42:06 -0700	             94
v2.6.19   	2006-09-19 20:42:06 -0700  -  2006-11-29 13:57:37 -0800	             71
v2.6.20   	2006-11-29 13:57:37 -0800  -  2007-02-04 10:44:54 -0800	             67
v2.6.21   	2007-02-04 10:44:54 -0800  -  2007-04-25 20:08:32 -0700	             80
v2.6.22   	2007-04-25 20:08:32 -0700  -  2007-07-08 16:32:17 -0700	             74
v2.6.23   	2007-07-08 16:32:17 -0700  -  2007-10-09 13:31:38 -0700	             93
v2.6.24   	2007-10-09 13:31:38 -0700  -  2008-01-24 14:58:37 -0800	             107
v2.6.25   	2008-01-24 14:58:37 -0800  -  2008-04-16 19:49:44 -0700	             83
v2.6.26   	2008-04-16 19:49:44 -0700  -  2008-07-13 14:51:29 -0700	             88
v2.6.27   	2008-07-13 14:51:29 -0700  -  2008-10-09 15:13:53 -0700	             88
v2.6.28   	2008-10-09 15:13:53 -0700  -  2008-12-24 15:26:37 -0800	             76
v2.6.29   	2008-12-24 15:26:37 -0800  -  2009-03-23 16:12:14 -0700	             89
v2.6.30   	2009-03-23 16:12:14 -0700  -  2009-06-09 20:05:27 -0700	             78
v2.6.31   	2009-06-09 20:05:27 -0700  -  2009-09-09 15:13:59 -0700	             92
v2.6.32   	2009-09-09 15:13:59 -0700  -  2009-12-02 19:51:21 -0800	             84
v2.6.33   	2009-12-02 19:51:21 -0800  -  2010-02-24 10:52:17 -0800	             84
v2.6.34   	2010-02-24 10:52:17 -0800  -  2010-05-16 14:17:36 -0700	             81
v2.6.35   	2010-05-16 14:17:36 -0700  -  2010-08-01 15:11:14 -0700	             77

v2.6.36 release estimate based on the last 35 kernels: Sat Oct  9 15:11:14 PDT 2010
v2.6.37 release estimate based on the last 35 kernels: Fri Dec 17 14:11:14 PST 2010
v2.6.38 release estimate based on the last 35 kernels: Thu Feb 24 14:11:14 PST 2011

mcgrof@tux ~/wireless-testing (git::master)$ phb-crystal-ball -c 10
Kernel	            Begin-of-hacking       -     End-of-hacking   	     Hacking-day--average
v2.6.27   	2008-07-13 14:51:29 -0700  -  2008-10-09 15:13:53 -0700	             88
v2.6.28   	2008-10-09 15:13:53 -0700  -  2008-12-24 15:26:37 -0800	             76
v2.6.29   	2008-12-24 15:26:37 -0800  -  2009-03-23 16:12:14 -0700	             89
v2.6.30   	2009-03-23 16:12:14 -0700  -  2009-06-09 20:05:27 -0700	             78
v2.6.31   	2009-06-09 20:05:27 -0700  -  2009-09-09 15:13:59 -0700	             92
v2.6.32   	2009-09-09 15:13:59 -0700  -  2009-12-02 19:51:21 -0800	             84
v2.6.33   	2009-12-02 19:51:21 -0800  -  2010-02-24 10:52:17 -0800	             84
v2.6.34   	2010-02-24 10:52:17 -0800  -  2010-05-16 14:17:36 -0700	             81
v2.6.35   	2010-05-16 14:17:36 -0700  -  2010-08-01 15:11:14 -0700	             77

v2.6.36 release estimate based on the last 10 kernels: Thu Oct 14 15:11:14 PDT 2010
v2.6.37 release estimate based on the last 10 kernels: Mon Dec 27 14:11:14 PST 2010
v2.6.38 release estimate based on the last 10 kernels: Fri Mar 11 14:11:14 PST 2011

mcgrof@tux ~/wireless-testing (git::master)$ phb-crystal-ball -c 3
Kernel	            Begin-of-hacking       -     End-of-hacking   	     Hacking-day--average
v2.6.34   	2010-02-24 10:52:17 -0800  -  2010-05-16 14:17:36 -0700	             81
v2.6.35   	2010-05-16 14:17:36 -0700  -  2010-08-01 15:11:14 -0700	             77

v2.6.36 release estimate based on the last 3 kernels: Wed Sep 22 15:11:14 PDT 2010
v2.6.37 release estimate based on the last 3 kernels: Sat Nov 13 14:11:14 PST 2010
v2.6.38 release estimate based on the last 3 kernels: Tue Jan  4 14:11:14 PST 2011

Cc: Dan Tian <dan.tian@atheros.com>
Cc: Kevin Hayes <kevin@atheros.com>
Cc: David Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: Zhifeng Cai <zhifeng.cai@atheros.com>
Cc: Kathy Giori <kathy.giori@atheros.com>
Cc: Cliff Holden <cliff.holden@atheros.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Charles Marker <charles.marker@atheros.com>
Cc: Bernadette Yetso <bernadette.yetso@atheros.com>
Cc: Satagopan Kanthadai <satagopan.kanthadai@atheros.com>
Cc: Senthilkumar Balasubramanian <senthilkumar.balasubramanian@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scripts/phb-crystal-ball |  137 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100755 scripts/phb-crystal-ball

diff --git a/scripts/phb-crystal-ball b/scripts/phb-crystal-ball
new file mode 100755
index 0000000..1ca6d90
--- /dev/null
+++ b/scripts/phb-crystal-ball
@@ -0,0 +1,137 @@
+#!/bin/bash
+# Copyright (c) 2010 Atheros Communications Inc.
+#
+#   Written by: Luis R. Rodriguez <lrodriguez@atheros.com>
+#
+# Permission to use, copy, modify, and/or distribute this software for any
+# purpose with or without fee is hereby granted, provided that the above
+# copyright notice and this permission notice appear in all copies.
+#
+# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+
+# Tired of guestimating to your bosses when the next kernel will be released?
+# Yeah, me too! Hope it helps.
+
+# Date calulation stuff is based on:
+# http://www.unix.com/tips-tutorials/31944-simple-date-time-calulation-bash.html
+# Credit to ripat there
+date_to_stamp () {
+	date --utc --date "$1" +%s
+}
+
+stamp_to_date () {
+	date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T"
+}
+
+date_diff () {
+	case $1 in
+		-s)   sec=1;      shift;;
+		-m)   sec=60;     shift;;
+		-h)   sec=3600;   shift;;
+		-d)   sec=86400;  shift;;
+		*)    sec=86400;;
+	esac
+	dte1=$(date_to_stamp $1)
+	dte2=$(date_to_stamp $2)
+	diffSec=$((dte2-dte1))
+	if ((diffSec < 0)); then abs=-1; else abs=1; fi
+	echo $((diffSec/sec*abs))
+}
+# End of date crap
+
+# Pretty colors
+GREEN="\033[01;32m"
+YELLOW="\033[01;33m"
+NORMAL="\033[00m"
+BLUE="\033[34m"
+RED="\033[31m"
+PURPLE="\033[35m"
+CYAN="\033[36m"
+UNDERLINE="\033[02m"
+
+usage() {
+	echo -en "Usage: ${GREEN}$0 ${NORMAL}[ ${CYAN}-c <num-kernels> ${NORMAL}]\n"
+}
+
+if [[ $# -ne 0 && $# -ne 2 ]]; then
+	usage
+	exit
+fi
+
+NUM_KERNELS=0
+
+if [[ $# -eq 2 ]]; then
+	if [[ $2 -lt 0 || $1 != "-c" ]]; then
+		usage
+		exit
+	fi
+	NUM_KERNELS=$2
+fi
+
+LIMIT=""
+
+# 2.6.11 and older are on the history kernel
+if [[ $NUM_KERNELS -ne 0 ]]; then
+	KERNELS=$(git tag -l| grep v2.6.| grep -v rc | perl -i -ne 'print if ( /v2.6.(\d+\d*)$/i ) ' | grep -v 2.6.11 | grep -v "-" | sort --sort=version | tail -${NUM_KERNELS})
+else
+	KERNELS=$(git tag -l| grep v2.6.| grep -v rc | perl -i -ne 'print if ( /v2.6.(\d+\d*)$/i ) ' | grep -v 2.6.11 | grep -v "-" | sort --sort=version)
+fi
+
+LAST_DATE=""
+KERNEL_COUNT=0
+KERNEL_HACKING_DAYS=0
+
+echo -en "${GREEN}Kernel\t${YELLOW}            Begin-of-hacking      ${NORMAL} -  ${YELLOW}   End-of-hacking   \t${CYAN}     Hacking-day-average\n"
+
+for i in $KERNELS; do
+	# Relies on the tag date, note the commit date
+	TAG_DATE=$(git log -2 --pretty=format:%ai $i | head -1)
+
+	if [[ $LAST_DATE = "" ]]; then
+		LAST_DATE="$TAG_DATE"
+		let COUNT=$COUNT+1
+		continue
+	fi
+
+	DAYS=$(date_diff -d "$LAST_DATE" "$TAG_DATE")
+
+	echo -en "${GREEN}$i   \t${YELLOW}${LAST_DATE}${NORMAL}  -  ${YELLOW}${TAG_DATE}\t${CYAN}             ${DAYS}\n"
+
+	LAST_DATE="$TAG_DATE"
+	LAST_KERNEL=$(echo $i | sed -e 's|v2.6.||')
+	let COUNT=$COUNT+1
+	let KERNEL_HACKING_DAYS=$KERNEL_HACKING_DAYS+$DAYS
+done
+
+if [[ $LAST_DATE = "" ]]; then
+	echo -en "Not enough kernels"
+fi
+
+echo -en "\n"
+
+# We round off the minutes, etc since date doesn't compute floating point days
+AVERAGE_HACKING_DAYS=$(($KERNEL_HACKING_DAYS / $COUNT))
+
+let NEXT=$LAST_KERNEL+1
+
+
+# http://en.wikipedia.org/wiki/Pointy-haired_Boss
+PHB_TOLERANCE=3
+PHB_LEVEL=0
+
+while [[ $PHB_LEVEL -lt $PHB_TOLERANCE ]]; do
+	PHB_CRYSTAL_BALL=$(date --date "$LAST_DATE +$AVERAGE_HACKING_DAYS days")
+
+	echo -en "${RED}v2.6.${NEXT} ${NORMAL}release estimate based on the "
+	echo -en "last ${GREEN}$COUNT ${NORMAL}kernels: ${CYAN}$PHB_CRYSTAL_BALL${NORMAL}\n"
+	LAST_DATE="$PHB_CRYSTAL_BALL"
+
+	let PHB_LEVEL=$PHB_LEVEL+1
+	let NEXT=$NEXT+1
+done
-- 
1.7.0.4

