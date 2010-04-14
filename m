Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0DNFyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:54:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34304 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0DNFyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:54:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100414054144.GH2493@dastard>
References: <20100414135945.2b0a1e0d.kamezawa.hiroyu@jp.fujitsu.com> <20100414054144.GH2493@dastard>
Message-Id: <20100414145056.D147.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 14 Apr 2010 14:54:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 14, 2010 at 01:59:45PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 14 Apr 2010 11:40:41 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > >  50)     3168      64   xfs_vm_writepage+0xab/0x160 [xfs]
> > >  51)     3104     384   shrink_page_list+0x65e/0x840
> > >  52)     2720     528   shrink_zone+0x63f/0xe10
> > 
> > A bit OFF TOPIC.
> > 
> > Could you share disassemble of shrink_zone() ?
> > 
> > In my environ.
> > 00000000000115a0 <shrink_zone>:
> >    115a0:       55                      push   %rbp
> >    115a1:       48 89 e5                mov    %rsp,%rbp
> >    115a4:       41 57                   push   %r15
> >    115a6:       41 56                   push   %r14
> >    115a8:       41 55                   push   %r13
> >    115aa:       41 54                   push   %r12
> >    115ac:       53                      push   %rbx
> >    115ad:       48 83 ec 78             sub    $0x78,%rsp
> >    115b1:       e8 00 00 00 00          callq  115b6 <shrink_zone+0x16>
> >    115b6:       48 89 75 80             mov    %rsi,-0x80(%rbp)
> > 
> > disassemble seems to show 0x78 bytes for stack. And no changes to %rsp
> > until retrun.
> 
> I see the same. I didn't compile those kernels, though. IIUC,
> they were built through the Ubuntu build infrastructure, so there is
> something different in terms of compiler, compiler options or config
> to what we are both using. Most likely it is the compiler inlining,
> though Chris's patches to prevent that didn't seem to change the
> stack usage.
> 
> I'm trying to get a stack trace from the kernel that has shrink_zone
> in it, but I haven't succeeded yet....

I also got 0x78 byte stack usage. Umm.. Do we discussed real issue now?




