Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2F2Ljd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:39:33 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44809 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2F2Ljc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:39:32 -0400
Date: Fri, 29 Jun 2012 13:39:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 03/23] perf: Add ability to attach user level registers
 dump to sample
Message-ID: <20120629113922.GD2110@somewhere.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
 <1340120894-9465-4-git-send-email-jolsa@redhat.com>
 <20120627151059.GG20638@somewhere.redhat.com>
 <CABPqkBTdL7rt4YF1SYdo4N7BaK3TOvXJqfs3Te2Asmm_-jA_Ag@mail.gmail.com>
 <20120627152359.GI20638@somewhere.redhat.com>
 <1340810729.10063.66.camel@twins>
 <20120627153002.GJ20638@somewhere.redhat.com>
 <20120629075043.GD940@krava.brq.redhat.com>
 <20120629112347.GB2110@somewhere.redhat.com>
 <20120629113012.GF6978@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629113012.GF6978@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 01:30:12PM +0200, Jiri Olsa wrote:
> On Fri, Jun 29, 2012 at 01:23:51PM +0200, Frederic Weisbecker wrote:
> 
> SNIP
> 
> > > 
> > > well, thats basically what we have now..
> > > 
> > > when the kernel is compiled for 32 bits, the bitmask allows to store:
> > > 
> > > ax, bx, cx, dx, si, di, bp, sp, ip, flags, cs, ds, es, fs, gs, ss
> > > 
> > > and when  kernel is compiled for 64 bits, the bitmask adds 64bit stuff:
> > > 
> > > ax, bx, cx, dx, si, di, bp, sp, ip, flags, cs, ds, es, fs, gs, ss
> > > r8, r9, r10, r11, r12, r13, r14, r15
> > > 
> > > 
> > > - 32 bits kernel is straightforward
> > > 
> > > - for 64 bits kernel we store whatever bitmask instructs to,
> > >   regardless if we are in compat task or native 64,
> > >   user space will deal with that in post processing
> > 
> > I can think of the crazy scenario where perf itself is compat and there
> > are 64 bits apps that will be profiled by perf. It means perf must check
> > if the kernel is 32 or 64 and depending on this, request r8-r15 or not.
> > 
> > May be that's just too unlikely to matter.
> 
> hopefully ;) anyway the kernel interface stays the same in this case as well
> 
> we can add this check later when/if we deal with compat tasks

Right!
