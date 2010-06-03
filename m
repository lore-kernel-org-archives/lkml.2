Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0FCRSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:18:08 -0400
Received: from kelvin.asmallorange.com ([207.210.111.10]:48291 "EHLO
	kelvin.asmallorange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0FCRSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:18:06 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 13:18:06 EDT
Date: Thu, 3 Jun 2010 22:48:12 +0530
From: Rabin Vincent <rabin@rab.in>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: decodecode: use /bin/bash
Message-ID: <20100603171812.GA23367@debian>
References: <1275581686-19745-1-git-send-email-rabin@rab.in>
 <20100603092458.d0d603e3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603092458.d0d603e3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - kelvin.asmallorange.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rab.in
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:24:58AM -0700, Randy Dunlap wrote:
> On Thu,  3 Jun 2010 21:44:46 +0530 Rabin Vincent wrote:
> 
> > 5358db ("scripts: add ARM support to decodecode") added a few bashims to
> > the decodecode script, so explicitly ask for bash.
> > 
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
> > ---
> > Alternatively, I have a patch to remove the bashisms, if that's preferred.
> 
> Yes, that's what we usually prefer to do.
> Please post it.

Here it is:

>From f729122bcd237f32c9f667e5644c6114ddc795af Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Thu, 3 Jun 2010 21:33:46 +0530
Subject: [PATCH] scripts: decodecode: remove bashisms

Remove bashisms to make scripts/decodecode work with other shells.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 scripts/decodecode |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/decodecode b/scripts/decodecode
index 8b30cc3..18ba881 100755
--- a/scripts/decodecode
+++ b/scripts/decodecode
@@ -40,7 +40,7 @@ echo $code
 code=`echo $code | sed -e 's/.*Code: //'`
 
 width=`expr index "$code" ' '`
-width=$[($width-1)/2]
+width=$((($width-1)/2))
 case $width in
 1) type=byte ;;
 2) type=2byte ;;
@@ -48,10 +48,10 @@ case $width in
 esac
 
 disas() {
-	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s &> /dev/null
+	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s > /dev/null 2>&1
 
-	if [ "$ARCH" == "arm" ]; then
-		if [ $width == 2 ]; then
+	if [ "$ARCH" = "arm" ]; then
+		if [ $width -eq 2 ]; then
 			OBJDUMPFLAGS="-M force-thumb"
 		fi
 
@@ -59,7 +59,7 @@ disas() {
 	fi
 
 	${CROSS_COMPILE}objdump $OBJDUMPFLAGS -S $1.o | \
-		grep -v "/tmp\|Disassembly\|\.text\|^$" &> $1.dis
+		grep -v "/tmp\|Disassembly\|\.text\|^$" > $1.dis 2>&1
 }
 
 marker=`expr index "$code" "\<"`
-- 
1.7.1

