Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0HQKtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:49:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36729 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0HQKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kzNlkSyokj+lTJHuFhqxzyGQY2Q9nHeOzx5gj5sgfl9jWp+OYMVq2XniR5onuig/gA
         SElI70yYKrqHFAKYd17D278vmM4IRSujjPaal2asP3MOPUYaeeIipiioFoOtv8v4a7bv
         KFt8PNIktSjAIOcgJkv3zJU8kS2DaztR2xiZ4=
Subject: Re: [PATCH] kconfig: Fix variable name typo in
 streamline_config.pl.
From: hiromu <hiromu1996@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Toralf Foerster <toralf.foerster@gmx.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
In-Reply-To: <20100817054318.GC5095@cr0.nay.redhat.com>
References: <1281845597.11566.5.camel@camp10-laptop>
	 <20100817054318.GC5095@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 19:49:18 +0900
Message-ID: <1282042158.7160.9.camel@hiromu-Macbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2010 at 01:43PM +0800, Américo Wang wrote:
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> BTW, I think we should add "use strict;" too.

Then I added "use strict;" to streamline_config.pl, I saw another
warings.

> Global symbol "$dir" requires explicit package name at
scripts/kconfig/streamline_config.pl line 286.
> Global symbol "$dir" requires explicit package name at
scripts/kconfig/streamline_config.pl line 287.
> Global symbol "$dir" requires explicit package name at
scripts/kconfig/streamline_config.pl line 288.

Then I added "my $dir;" to line 285.

Cc: Américo Wang <xiyou.wangcong@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Toralf Foerster <toralf.foerster@gmx.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
---
 scripts/kconfig/streamline_config.pl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl
b/scripts/kconfig/streamline_config.pl
index d74363f..9ca361a 100644
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
@@ -280,6 +282,7 @@ if (defined($lsmod_file)) {
 
     # see what modules are loaded on this system
     my $lsmod;
+    my $dir;
 
     foreach $dir ( ("/sbin", "/bin", "/usr/sbin", "/usr/bin") ) {
        if ( -x "$dir/lsmod" ) {
-- 
1.7.0.4

