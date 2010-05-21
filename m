Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0EUNYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:24:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0EUNYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:24:32 -0400
Date: Fri, 21 May 2010 09:24:07 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: fweisbec <fweisbec@gmail.com>, mingo <mingo@elte.hu>,
       rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/14] tracing: add compat syscall support v3
Message-ID: <20100521132405.GA2109@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
 <1274433809-sup-5031@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274433809-sup-5031@au1.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 07:40:21PM +1000, Ian Munsie wrote:
> Hi Jason,
> 
> I'm currently in the process of implementing syscall tracepoints for
> PowerPC, and a considerable amount of my work is going to end up
> requiring these patches of yours. I've reviewed and tested your patches
> (and spent a good chunk of time rebasing them on top of
> tip/tracing/core) and they all seem pretty good.
> 
> I *particularly* like the way in which they prevent ftrace syscalls from
> reporting that sys_swapoff was constantly firing on x86_64 kernels with
> a 32bit userspace ;)
> 
> Anyway, I'm just wondering if you have an ETA for the v4 patchset to
> address the remaining issues that Frederic raised so that they can be
> merged.
> 
> Cheers,
> -Ian
> 

hi Ian,

I think the main issue left was that I am using the same meta data for
both the 32-bit and 64-bit table entries, when they reference the same
syscall. for example, for x86 both the compat and underlying 64-bit
kernel reference 'sys_rename'. Thus, i am pointing both perf events at
the same meta data. Frederic was saying they need to be separate. I'm
not sure i completely understand why, since the 32-bit are just sign
extended to 64-bit in this case. Frederic, perhaps, you can explain this
a bit more for me?

thanks,

-Jason
