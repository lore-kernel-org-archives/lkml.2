Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0KXV1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 16:27:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0KXV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 16:27:19 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=zd76gMVDP8oA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=ZHuW213a5PPuM921CWsA:9 a=xCOGtt_LFsbaLgq7t6y0UqYlO18A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101124212333.808256210@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 16:23:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [RFC][PATCH 0/2] Move kmalloc tracepoints out of inlined code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone have any objections to this code?

Tracepoints do carry a bit of weight and having them in a common
inlined function such as kmalloc() adds a bit of bloat to the kernel.

This is an RFC patch (to get comments) and hopefully will be something
to pull in for 2.6.38. It should not change the functionality
of the tracepoints, that is, you should still get the same result
from them as we have before. Just they are now inside the sl*b C code
instead of being scattered about the kernel.

If you are fine with these patches, please add your Acked-by.

Thanks,

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/trace


Steven Rostedt (2):
      tracing/slab: Move kmalloc tracepoint out of inline code
      tracing/slub: Move kmalloc tracepoint out of inline code

----
 include/linux/slab_def.h |   33 +++++++++++++--------------------
 include/linux/slub_def.h |   46 +++++++++++++++++++++-------------------------
 mm/page_alloc.c          |   14 ++++++++++++++
 mm/slab.c                |   38 +++++++++++++++++++++++---------------
 mm/slub.c                |   27 +++++++++++++++++++--------
 5 files changed, 90 insertions(+), 68 deletions(-)
