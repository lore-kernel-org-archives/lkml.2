Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0J2FpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:45:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab0J2Fo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:44:27 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=-7ZraIGOge4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=omOdbC7AAAAA:8 a=h1aNt0RaAAAA:8 a=meVymXHHAAAA:8 a=9wWOKH-WM6l7ght3Bq0A:9 a=XLVRj-_yJqwU5KrLzEUA:7 a=8gMXIGigRGgWJKkwTZUAOtJdSpYA:4 a=MSl-tDqOz04A:10 a=_RhRFcbxBZMA:10 a=9n0VZpmWo7gA:10 a=jeBq3FmKZ4MA:10 a=HKqJki_6tSJPTga2:21 a=XAYtitudVnrUNiRB:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029054424.066991090@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 01:43:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        =?ISO-8859-15?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
        Toralf Foerster <toralf.foerster@gmx.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hiromu Yakura <hiromu1996@gmail.com>
Subject: [PATCH 3/5] [PATCH 3/5] kconfig: Fix missing declaration of variable $dir in streamline_config.pl
References: <20101029054310.790179545@goodmis.org>
Content-Disposition: inline; filename=0003-kconfig-Fix-missing-declaration-of-variable-dir-in-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hiromu <hiromu1996@gmail.com>

On Fri, Aug 17, 2010 at 01:43PM +0800, Américo Wang wrote:
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> BTW, I think we should add "use strict;" too.

Then I added "use strict;" to streamline_config.pl, I saw another
warning.

> Global symbol "$dir" requires explicit package name at
scripts/kconfig/streamline_config.pl line 286.
> Global symbol "$dir" requires explicit package name at
scripts/kconfig/streamline_config.pl line 287.
> Global symbol "$dir" requires explicit package name at
scripts/kconfig/streamline_config.pl line 288.

Then I added "my $dir;" to line 285.

Cc: Américo Wang <xiyou.wangcong@gmail.com>
Cc: Toralf Foerster <toralf.foerster@gmx.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
LKML-Reference: <1282042158.7160.9.camel@hiromu-Macbook>

[ changed to just add my in front of $dir instead of new line ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 3c63aa9..883748c 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -42,6 +42,8 @@
 #    mv config_strip .config
 #    make oldconfig
 #
+use strict;
+
 my $config = ".config";
 
 my $uname = `uname -r`;
@@ -291,7 +293,7 @@ if (defined($lsmod_file)) {
     # see what modules are loaded on this system
     my $lsmod;
 
-    foreach $dir ( ("/sbin", "/bin", "/usr/sbin", "/usr/bin") ) {
+    foreach my $dir ( ("/sbin", "/bin", "/usr/sbin", "/usr/bin") ) {
 	if ( -x "$dir/lsmod" ) {
 	    $lsmod = "$dir/lsmod";
 	    last;
-- 
1.7.1


