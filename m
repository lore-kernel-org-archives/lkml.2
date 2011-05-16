Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1EPR0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:26:09 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:49476 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1EPR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:26:07 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 13:26:07 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QUCyZEUxO/klNj+DnnORywVTIJ2uB5p+prtTXNOBBJZo/mzcnB8RRstRqC9GJ2Hg/y
         3xi5vNCAH5L31iGgUH+oSZWjtAnZ9Xedm28J5xc1xq0PM+dVf5GyqZ+sBC61CGr7xm6X
         Y5MK3n2zl98SHlb51WUouFY4PwDwpgwzQjA5g=
Date: Mon, 16 May 2011 19:20:58 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: Ptrace documentation, draft #1
Message-ID: <20110516172058.GD20624@htj.dyndns.org>
References: <201105152235.32073.vda.linux@googlemail.com>
 <20110516153122.GA15856@redhat.com>
 <20110516155253.GA20624@htj.dyndns.org>
 <20110516165352.GA18727@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516165352.GA18727@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 06:53:52PM +0200, Oleg Nesterov wrote:
> > If you do GETSIGINFO and look at si->si_code, user generated signals
> > can't have non-zero value there
> 
> Hmm. The can? sys_kill() sets si_code = 0, but tkill() or queueinfo()
> can pass any si_code < 0. Also, the kernel can generate the signal
> with si_code > 0.

Yeah, sure, not non-zero then, but it's still distinguishible, no?

> > so, if si->si_code contains SIGTRAP | PTRACE_EVENT_* << 8,
> 
> But in this case (without PT_TRACE_EXEC) the tracee simply sends SIGTRAP
> to itself. It will be reported later like a normal signal.

Ah, okay, I missed the context.  I thought we were talking about
GETSIGINFO after traps not the extra SIGTRAP after execve.  Sorry
about that.  :-)

> > Maybe we can remove these if SEIZED?
> 
> Heh... I am not sure.

Yeah, I'm not sure either.  I think the most reasonable solution would
be leaving them alone but strongly discourage their use.

> Hmm. What do you mean? tracehook_report_syscall_exit() can skip
> ptrace_report_syscall() if step, but this is another story. And in this
> case the tracee sends the real signal to itself, unlike
> tracehook_signal_handler() which does ptrace_notify().

Please disregard.  Still was fixated on GETSIGINFO.

Thanks.

-- 
tejun
