Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1ATViu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:38:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab1ATVit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:38:49 -0500
Date: Thu, 20 Jan 2011 16:36:07 -0500
From: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [RFC -v6 PATCH 6/8] export pid symbols needed for kvm_vcpu_on_spin
Message-ID: <20110120163607.626844ab@annuminas.surriel.com>
In-Reply-To: <20110120163127.2568f4fe@annuminas.surriel.com>
References: <20110120163127.2568f4fe@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the symbols required for a race-free kvm_vcpu_on_spin.

Signed-off-by: Rik van Riel <riel@redhat.com>

diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..adc8f47 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -191,6 +191,7 @@ void __put_task_struct(struct task_struct *tsk)
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL_GPL(__put_task_struct);
 
 /*
  * macro override instead of weak attribute alias, to workaround
diff --git a/kernel/pid.c b/kernel/pid.c
index 39b65b6..02f2212 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -435,6 +435,7 @@ struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 	rcu_read_unlock();
 	return pid;
 }
+EXPORT_SYMBOL_GPL(get_task_pid);
 
 struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
 {
@@ -446,6 +447,7 @@ struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
 	rcu_read_unlock();
 	return result;
 }
+EXPORT_SYMBOL_GPL(get_pid_task);
 
 struct pid *find_get_pid(pid_t nr)
 {

