Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1DLOvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:51:17 -0400
Received: from kroah.org ([198.145.64.141]:57604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab1DLOiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:53 2011
Message-Id: <20110412143553.185393271@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [049/105] perf: Rebase max unprivileged mlock threshold on top of page size
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 20443384fe090c5f8aeb016e7e85659c5bbdd69f upstream.

Ensure we allow 512 kiB + 1 page for user control without
assuming a 4096 bytes page size.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1301535209-9679-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -62,8 +62,8 @@ static struct srcu_struct pmus_srcu;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-/* Minimum for 128 pages + 1 for the user control page */
-int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
+/* Minimum for 512 kiB + 1 user control page */
+int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
 
 /*
  * max perf event sample rate


