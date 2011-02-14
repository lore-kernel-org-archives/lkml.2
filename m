Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1BNQdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:33:52 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39985 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1BNQdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MunyjeYi4jNasGQ1lt33e4ne3TapmeYRTFSyVoAkwz4RYa2cz2KTxgMsfoBbnLoLtB
         qy41wViXImxzbv9OdwGmnOOHAlag/h3fPBMkZuxQ5kPqrkYbYg7jvqypYrI60kZmBm6o
         8KB413Ad29HVwUMbU9vTUwvDnRg3c93Ns8qNA=
Date: Mon, 14 Feb 2011 17:33:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110214163346.GZ18742@htj.dyndns.org>
References: <20110204105343.GA12133@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <20110214161515.GA11605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214161515.GA11605@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 05:15:15PM +0100, Oleg Nesterov wrote:
> > > PTRACE_CONT in this situation would do the same.
> >
> > This can be fixed by updating strace, right?  strace can look at the
> > wait(2) exit code and if the tracee stopped for group stop, wait for
> > the tracee to be continued instead of issuing PTRACE_SYSCALL.
> 
> Yes, in this particular case strace could be more clever.
> 
> But. The tracee should react to SIGCONT after that, this means we
> shouldn't "delay" this stop or force the TASK_TRACED state.

Yeap, which is achievable by treating group stop differently from
ptrace traps and make it proceed to TASK_TRACED only if ptrace wants
to issue commands.  (reiterating just to make sure there's no
misunderstanding)

> And note that in this case real_parent == debugger. Another case
> is more interesting, and this means we shouldn't delay or hide the
> notifications.
> 
> (I just tried to summarize the previous discussion for Denys)

Agreed.  We should be notifying both the real parent and ptracer.

Thanks.

-- 
tejun
