Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1EPDCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 23:02:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51859 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab1EPDCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 23:02:15 -0400
Date: Mon, 16 May 2011 13:02:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Eric Paris <eparis@redhat.com>
Subject: linux-next: manual merge of the security-testing tree with Linus'
 tree
Message-Id: <20110516130209.0477a9e7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Today's linux-next merge of the security-testing tree got a conflict in
include/linux/capability.h between commit 47a150edc2ae ("Cache user_ns in
struct cred") from Linus' tree and commit ffa8e59df047 ("capabilities: do
not drop CAP_SETPCAP from the initial task") from the security-testing
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/capability.h
index d4675af,04fed72..0000000
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@@ -546,8 -541,21 +541,10 @@@ extern bool has_capability_noaudit(stru
  extern bool capable(int cap);
  extern bool ns_capable(struct user_namespace *ns, int cap);
  extern bool task_ns_capable(struct task_struct *t, int cap);
 +extern bool nsown_capable(int cap);
  
+ extern const kernel_cap_t __cap_empty_set;
+ 
 -/**
 - * nsown_capable - Check superior capability to one's own user_ns
 - * @cap: The capability in question
 - *
 - * Return true if the current task has the given superior capability
 - * targeted at its own user namespace.
 - */
 -static inline bool nsown_capable(int cap)
 -{
 -	return ns_capable(current_user_ns(), cap);
 -}
 -
  /* audit system wants to get cap info from files as well */
  extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
  
