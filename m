Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1HARKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:10:52 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:53025 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1HARKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:10:48 -0400
Date: Mon, 1 Aug 2011 21:10:42 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Marc Zyngier <maz@misterjones.org>
Cc: Richard Weinberger <richard@nod.at>, serge.hallyn@canonical.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
Subject: Re: shm updates broke UML
Message-ID: <20110801171042.GA25954@albatros>
References: <201108011541.59640.richard@nod.at>
 <20110801134911.GA11705@albatros>
 <43e4e9e98b32d3d3eb06ab837a019ad8@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e4e9e98b32d3d3eb06ab837a019ad8@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 18:01 +0200, Marc Zyngier wrote:
> It also breaks ARM (at least 11MPCore and Cortex A9).
> The same workaround gets the kernel booting again.

Can you please apply this patch and show the output? 
I suppose all numbers will be nonNULL and the last is NULL.

diff --git a/ipc/shm.c b/ipc/shm.c
index bf46636..8e48ad8 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -304,6 +304,12 @@ void exit_shm(struct task_struct *task)
 {
 	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
 
+	pr_err("ns = %p, ids = %p",
+		ns, ns ? &shm_ids(ns) : (void*)(-2));
+	pr_err("wait_list = %p\n", ns ? &shm_ids(ns) ?
+		 &shm_ids(ns).rw_mutex.wait_list : (void*)(-1) : (void*)(-2));
+	pr_err("next = %p\n", shm_ids(ns).rw_mutex.wait_list.next);
+
 	/* Destroy all already created segments, but not mapped yet */
 	down_write(&shm_ids(ns).rw_mutex);
 	if (&shm_ids(ns).in_use)
--
