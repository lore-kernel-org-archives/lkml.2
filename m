Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2HJJ75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:59:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab2HJJ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:59:56 -0400
Date: Fri, 10 Aug 2012 11:59:53 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Inconsistent kallsyms data" error
Message-ID: <20120810095953.GA18851@sepie.suse.cz>
References: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
 <20120707214033.GA5303@pobox.suse.cz>
 <alpine.LNX.2.01.1208100202070.4234@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1208100202070.4234@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 02:02:33AM +0200, Jan Engelhardt wrote:
> 
> On Saturday 2012-07-07 23:40, Michal Marek wrote:
> >index cd9c6c6..4629038 100644
> >--- a/scripts/link-vmlinux.sh
> >+++ b/scripts/link-vmlinux.sh
> >@@ -210,8 +210,8 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
> > 	mksysmap ${kallsyms_vmlinux} .tmp_System.map
> > 
> > 	if ! cmp -s System.map .tmp_System.map; then
> >-		echo Inconsistent kallsyms data
> >-		echo echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
> >+		echo >&2 Inconsistent kallsyms data
> >+		echo >&2 echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
> 
> Hm why is there echo twice in that one line? Seems like an oversight..

Good catch.

>From 367e43c50d7f7c3b0cec17f4d855a96f47f5e17b Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Fri, 10 Aug 2012 11:55:11 +0200
Subject: [PATCH] link-vmlinux.sh: Fix stray "echo" in error message

Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/link-vmlinux.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 4629038..4235a63 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -211,7 +211,7 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 
 	if ! cmp -s System.map .tmp_System.map; then
 		echo >&2 Inconsistent kallsyms data
-		echo >&2 echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
+		echo >&2 Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
 		cleanup
 		exit 1
 	fi
