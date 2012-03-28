Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2C1QKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:10:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45169 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2C1QKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:10:51 -0400
Date: Wed, 28 Mar 2012 18:10:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, acme@redhat.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, linux-kernel@vger.kernel.org, mjw@redhat.com
Subject: Re: [PATCH 04/15] perf: Add ability to dump user regs
Message-ID: <20120328161043.GI17189@somewhere.redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
 <1332938158-5244-5-git-send-email-jolsa@redhat.com>
 <20120328140115.GE4826@redhat.com>
 <20120328142021.GC1647@m.brq.redhat.com>
 <20120328151230.GF4826@redhat.com>
 <20120328160156.GD1647@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328160156.GD1647@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 06:01:56PM +0200, Jiri Olsa wrote:
> On Wed, Mar 28, 2012 at 11:12:30AM -0400, Frank Ch. Eigler wrote:
> > Hi, Jiri -
> > 
> > > [...]
> > > > [...]  Upon a normal syscall entry to the kernel, not
> > > > all user registers are saved explicitly for such easy retrieval.  The
> > > > others may be spilled to the stack by gcc during the various sys_*
> > > > functions or elsewhere.  [...]
> > > 
> > > Are you reffering to x86_64 where only portion of registers
> > > is stored by SAVE_ARGS macro? Seems like 32 bits stores the
> > > whole pt_regs.
> > 
> > I believe that's the right area.  I'm not sure even the 32-bit variant
> > is complete enough, for example exempting MMX/SSE registers.  These
> > may also contain spilled registers before long.
> 
> right, I covered only general registers... need to check about mmc/sse

I think you can forget that. At least for now.

I believe in most cases you'll only need rsp for the unwinding. Then on some
tricky frame setups you might need more general registers values but I guess
this shouldn't be too frequent.

But you won't need MMX/SSE.
