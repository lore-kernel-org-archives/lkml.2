Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab0DGNPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:15:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:50116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab0DGNPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:15:31 -0400
Subject: Re: [PATCH] perf_events: add PERF_SAMPLE_BRANCH_STACK
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4bbc7fcf.100db80a.6b9f.fffffb14@mx.google.com>
References: <4bbc7fcf.100db80a.6b9f.fffffb14@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 15:15:27 +0200
Message-ID: <1270646127.20295.976.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 14:45 +0200, Stephane Eranian wrote:
>         LBR is configured by default to record ALL taken branches.  On some
>         processors, it is possible to filter the type of branches. This will
>         be supported in a subsequent patch.
> 
>         On other processors, the sample type is allowed but will generate a
>         sample where nr=0 as is the case with other sampling types.

Right, so I already posted a patch like that:
  http://lkml.org/lkml/2010/3/4/160

and the reason its not merged is because there is no perf use-case for
it. Ingo wants to avoid merging ABI bits for which there is no userspace
around. We already have a few such things and we find that its too easy
to regress on those part.

So if you want this, please also implement a useful use-case in perf.

