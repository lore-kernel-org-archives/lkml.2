Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992444Ab2KNWay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:30:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945904Ab2KNWax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:30:53 -0500
Date: Wed, 14 Nov 2012 14:30:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: don't BUG when we can trivially return a
 proper error.
Message-Id: <20121114143052.7ebe8947.akpm@linux-foundation.org>
In-Reply-To: <20121114221544.GA3083@elliptictech.com>
References: <1351796580-20600-1-git-send-email-nbowler@elliptictech.com>
	<20121114130500.250dd5b8.akpm@linux-foundation.org>
	<20121114221544.GA3083@elliptictech.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 17:15:44 -0500
Nick Bowler <nbowler@elliptictech.com> wrote:

> > Unfortunately there is no EKERNELSCREWEDUP,
> 
> Well, maybe we should add it! :P

Well.  Given how frequently it will be used, it would need to be a much
shorter identifier.  Perhaps "EEK".  Or just "E".

> > so we usually use EINVAL.
> 
> Fair enough.  I will prepare v2.  But perhaps EOPNOTSUPP would be a
> better fit?

I have queued a delta:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix

s/E2BIG/EINVAL/

Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/scatterlist.c~scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix
+++ a/lib/scatterlist.c
@@ -249,7 +249,7 @@ int __sg_alloc_table(struct sg_table *ta
 
 #ifndef ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
-		return -E2BIG;
+		return -EINVAL;
 #endif
 
 	memset(table, 0, sizeof(*table));
_

