Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2CZAyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 20:54:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37250 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2CZAyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 20:54:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6FBDEC.5040605@jp.fujitsu.com>
Date: Mon, 26 Mar 2012 09:53:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: last fs/proc/array.c change
References: <CAOPLpQe+SP7Nvr_EU44hcCu3UXVtF84EmL-_eskA1UfGr6JrPQ@mail.gmail.com>
In-Reply-To: <CAOPLpQe+SP7Nvr_EU44hcCu3UXVtF84EmL-_eskA1UfGr6JrPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/24 21:26), Ulrich Drepper wrote:


> See the second to last seq_put_decimal_ull.  This is a copy&paste
> mistake since given the original format it should read
> 
> +       seq_put_decimal_ull(m, ' ', data);
> 
> (i.e., data instead of text).

Thank you for finding..

==
Subject: [PATCH] proc: fix /proc/statm

The patch 'procfs: speed up /proc/pid/stat, statm' breaks /proc/statm
and 'text' is printed twice by mistake.

Reported-by: drepper@gmail.com
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/array.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index fbb53c2..f9bd395 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -550,7 +550,7 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 	seq_put_decimal_ull(m, ' ', shared);
 	seq_put_decimal_ull(m, ' ', text);
 	seq_put_decimal_ull(m, ' ', 0);
-	seq_put_decimal_ull(m, ' ', text);
+	seq_put_decimal_ull(m, ' ', data);
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_putc(m, '\n');
 
-- 
1.7.4.1


