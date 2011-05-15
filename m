Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab1EOQrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:47:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42054 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab1EOQrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CNNIg3kLqcLjx3pQ7kl7JeVHHCFIpGuNdcdmeJS6MeTVCrCd/iVLou1xRv5MyQGXhp
         i9YQIW/HaAt/WKPnZhsx3/eUIVi+ZnbqQwOeP9FoQQ7EnPwdkpiPjwR35HGXFUzUbXgX
         RRW9jMkIXxCBWjj4Yc+moU+33QTPlMtlahbGo=
Date: Sun, 15 May 2011 18:47:05 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110515164705.GI23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515144017.GC31855@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Sun, May 15, 2011 at 04:40:17PM +0200, Jan Kratochvil wrote:
> It may be not related, I do not inderstand the kernel internals being
> discussed.
> 
> I was told by Roland McGrath that after SIGCHLD of a ptrace even from tracee
> invokes sighandler for that SIGCHLD in the tracer then waitpid(WNOHANG) still
> may return 0 as the signal is not yet ready.  I was not able to reproduce it
> with a testcase myself.

Hmmm... I could easily be wrong but AFAICS that shouldn't happen.  If
you can reproduce the problem, please let us know.

> But if it is a case it should be fixed as there is no later notification when
> to call waitpid(WNOHANG) again.  And sure the debugger cannot busy-loop poll
> it.

But, the current WNOHANG wait is racy.  It's unlikely but definitely
possible for WNOHANG to fail when it's expected to succeed (not the
above case but more convoluted ones).

But, just out of curiosity, is there any reason the ptracer itself
should be doing something other than waitpid() while tracee is
running?  It's not like ptrace requests can be issued during that time
and sleeping waitpid() is way saner mechanism to wait for tracee
events than signal.

Thanks.

-- 
tejun
