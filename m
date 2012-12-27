Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2L0KsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 05:48:11 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:47251 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2L0KsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 05:48:03 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
CC: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] modpost: Ignore ARC specific non-alloc sections
Date: Thu, 27 Dec 2012 16:17:20 +0530
Message-ID: <1356605240-4555-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356605240-4555-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-21-git-send-email-vgupta@synopsys.com>
 <1356605240-4555-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARC relocatable object files contain one/more .gnu.linkonce.arcextmap.*
sections (collated by kernel/vmlinux.lds into .arcextmap in final link).
This section is used by debuggers to display the extension instructions
and need-not be loaded by target (hence !SHF_ALLOC)

The final kernel binary only needs .arcextmap entry in modpost's ignore
list (section_white_list[]). However when building modules, modpost scans
each object file individually, hence tripping on non-aggregated
.gnu.linkonce.arcextmap.* entries as well.

Thus need for the 2 entires !

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 scripts/mod/modpost.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0d93856..f6f1030 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -830,6 +830,8 @@ static const char *section_white_list[] =
 	".toc*",
 	".xt.prop",				 /* xtensa */
 	".xt.lit",         /* xtensa */
+	".arcextmap*",			/* arc */
+	".gnu.linkonce.arcext*",	/* arc : modules */
 	NULL
 };
 
-- 
1.7.4.1

