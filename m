Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab2CMDKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:10:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29673 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759464Ab2CMDKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:10:36 -0400
Message-ID: <4F5EBAA7.50709@oracle.com>
Date: Tue, 13 Mar 2012 11:10:31 +0800
From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20101209)
MIME-Version: 1.0
To: ebiederm@xmission.com
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kexec: add further check to crashkernel
References: <1329989047-20378-1-git-send-email-zhenzhong.duan@oracle.com>
In-Reply-To: <1329989047-20378-1-git-send-email-zhenzhong.duan@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020203.4F5EBAA9.0045,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

When add crashkernel=2M-256M, kernel don't give any warning.
This is misleading sometimes.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 kernel/kexec.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 7b08867..0a6d147 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1359,6 +1359,10 @@ static int __init parse_crashkernel_simple(char 		*cmdline,
 
 	if (*cur == '@')
 		*crash_base = memparse(cur+1, &cur);
+	else if (*cur != ' ' && *cur != '\0') {
+		pr_warning("crashkernel: unrecognized char\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 1.7.3

