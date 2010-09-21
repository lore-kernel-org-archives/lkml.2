Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0IUH0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0IUH0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:26:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
        tdm.rhbz@gmail.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
Date: Tue, 21 Sep 2010 09:26:35 +0200
Message-Id: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CPU type detection for dunnington processor (Family 6 / Model 29)
to be identified as core 2 family cpu type (wikipedia source).

I tested oprofile on Intel(R) Xeon(R) CPU E7440 reporting itself as model 29,
and it runs without an issue.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/oprofile/nmi_int.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 009b819..f1575c9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -674,6 +674,7 @@ static int __init ppro_init(char **cpu_type)
 	case 0x0f:
 	case 0x16:
 	case 0x17:
+	case 0x1d:
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:
-- 
1.7.1

