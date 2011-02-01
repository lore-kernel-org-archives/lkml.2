Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab1BAOyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab1BAOyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:54:07 -0500
Date: Tue, 1 Feb 2011 09:51:46 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [PATCH -v8a 5/7] export pid symbols needed for kvm_vcpu_on_spin
Message-ID: <20110201095146.5212a80a@annuminas.surriel.com>
In-Reply-To: <20110201094433.72829892@annuminas.surriel.com>
References: <20110201094433.72829892@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

