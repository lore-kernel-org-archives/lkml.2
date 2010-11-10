Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0KJDcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 22:32:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47102 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0KJDcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 22:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tnnViLfr6ftDaciBWqXjkPMwem43gz/ujkSXVhWknM1lEAp1/80f3x+9yTKminX1Nn
         B9o9hNuvKWiHEtlGPn+LvEYXApvBxB+l5tP+veidTUGccgDRhn331Lfr3Z6/Eqtrn5fo
         RJ+VXAXpXDD3261lnggmfxGxRQAa/uZKcNI8k=
Date: Wed, 10 Nov 2010 11:31:55 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH] APPARMOR: Fix memory leak of alloc_namespace()
Message-ID: <20101110033155.GA2873@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

policy->name is a substring of policy->hname, if prefix is not NULL, it will 
allocted strlen(prefix) + strlen(name) + 3 bytes to policy->hname in policy_init(). 
use kzfree(ns->base.name) will casue memory leak if alloc_namespace() failed.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/apparmor/policy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 52cc865..4f0eade 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -306,7 +306,7 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 	return ns;
 
 fail_unconfined:
-	kzfree(ns->base.name);
+	kzfree(ns->base.hname);
 fail_ns:
 	kzfree(ns);
 	return NULL;
-- 
1.6.5.3

