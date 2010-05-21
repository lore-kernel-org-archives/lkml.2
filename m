Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0EUNbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:31:13 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49475 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0EUNbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NFiruOs8haecqljizQ6R4aPtdvcb8PtZp3qULIhcSaUaZxxcnZug+VVXA2DjfwMrab
         Hv1qn9EqRwDyQ7lguPcZSuIwwRPBEmov5PQCgbb5g4qsQiIsIR4JWYOqK5qT4JDLe44J
         3oVmWq4QXXKKEbHixBXwyFurbMswsIEbJRgOI=
Date: Fri, 21 May 2010 15:31:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>, mingo <mingo@elte.hu>,
       rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/14] tracing: add compat syscall support v3
Message-ID: <20100521133117.GJ30108@nowhere>
References: <cover.1268749695.git.jbaron@redhat.com> <1274433809-sup-5031@au1.ibm.com> <20100521132405.GA2109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521132405.GA2109@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 09:24:07AM -0400, Jason Baron wrote:
> On Fri, May 21, 2010 at 07:40:21PM +1000, Ian Munsie wrote:
> > Hi Jason,
> > 
> > I'm currently in the process of implementing syscall tracepoints for
> > PowerPC, and a considerable amount of my work is going to end up
> > requiring these patches of yours. I've reviewed and tested your patches
> > (and spent a good chunk of time rebasing them on top of
> > tip/tracing/core) and they all seem pretty good.
> > 
> > I *particularly* like the way in which they prevent ftrace syscalls from
> > reporting that sys_swapoff was constantly firing on x86_64 kernels with
> > a 32bit userspace ;)
> > 
> > Anyway, I'm just wondering if you have an ETA for the v4 patchset to
> > address the remaining issues that Frederic raised so that they can be
> > merged.
> > 
> > Cheers,
> > -Ian
> > 
> 
> hi Ian,
> 
> I think the main issue left was that I am using the same meta data for
> both the 32-bit and 64-bit table entries, when they reference the same
> syscall. for example, for x86 both the compat and underlying 64-bit
> kernel reference 'sys_rename'. Thus, i am pointing both perf events at
> the same meta data. Frederic was saying they need to be separate. I'm
> not sure i completely understand why, since the 32-bit are just sign
> extended to 64-bit in this case. Frederic, perhaps, you can explain this
> a bit more for me?
> 
> thanks,
> 
> -Jason


If they are pointing to the same function with the same parameters, then
yeah it's fine.

I think I worried about two different handlers that don't have the
exact same parameters (one having compat things, and the other having
not). But now that I think about it that's probably not what you did.

I'll give another shot to this patchset then, as I've probably confused
something, I just need to wait a bit for the giant patchset from Steve
on trace events to be applied, before applying this set. Should happen
soon.

Will look at this next week.
Thanks.

