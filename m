Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab1FWR6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:58:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:35128 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933604Ab1FWRhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kamal Mostafa <kamal@canonical.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 172/247] x86: Fix panic when handling "mem={invalid}" param
Date: Thu, 23 Jun 2011 13:34:00 -0400
Message-Id: <1308850515-15242-113-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamal Mostafa <kamal@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 77eed821accf5dd962b1f13bed0680e217e49112 upstream.

Avoid removing all of memory and panicing when "mem={invalid}"
is specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on
platforms other than x86_32).

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
BugLink: http://bugs.launchpad.net/bugs/553464
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1296783486-23033-1-git-send-email-kamal@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/e820.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7bca3c6..4267f42 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -989,6 +989,9 @@ static int __init parse_memopt(char *p)
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
-- 
1.7.4.4

