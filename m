Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1AGOO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:14:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab1AGOOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:14:55 -0500
Date: Fri, 7 Jan 2011 15:14:54 +0100
From: Michal Hocko <mhocko@suse.cz>
To: John Johansen <john.johansen@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] apparmor: cleanup generated files correctly
Message-ID: <20110107141453.GD1891@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,
could you consider the patch bellow. The issue is minor but I guess it
is worth having fixed.
---
>From a6b164aeff1234708595d06dd6f9abeb59564da6 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 7 Jan 2011 15:03:02 +0100
Subject: [PATCH] apparmor: cleanup generated files correctly

clean-files should be defined as a variable not a target.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 security/apparmor/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
index f204869..bbb942a 100644
--- a/security/apparmor/Makefile
+++ b/security/apparmor/Makefile
@@ -6,7 +6,7 @@ apparmor-y := apparmorfs.o audit.o capability.o context.o ipc.o lib.o match.o \
               path.o domain.o policy.o policy_unpack.o procattr.o lsm.o \
               resource.o sid.o file.o
 
-clean-files: capability_names.h af_names.h
+clean-files := capability_names.h af_names.h
 
 quiet_cmd_make-caps = GEN     $@
 cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ; sed -n -e "/CAP_FS_MASK/d" -e "s/^\#define[ \\t]\\+CAP_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@
-- 
1.7.2.3

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
