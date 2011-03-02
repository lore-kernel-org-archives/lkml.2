Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1CBPbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:31:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1CBPbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aoQGpMtULmzjFYKW5AQqOl4mmbfREYGvgc8hf2LL8VsMzIedjI9x/lOcKCCM+Wqra1
         SmOrPxcB2+BX4glH284R7tq+bswZKLa/KgpcK7IhjOWAzVexhkGDW2ePUKd/8DCxmy6L
         zyWX7Khdy7wW30Lh1RpPU5ZM15VudTIQvq7to=
Date: Wed, 2 Mar 2011 16:25:50 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302152550.GM3319@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
 <20110302073727.GD19669@htj.dyndns.org>
 <AANLkTimA8wtM4sJu1SMVuOaNXyxEtLcfaj7kJf2NovAd@mail.gmail.com>
 <20110302112756.GI3319@htj.dyndns.org>
 <AANLkTi=tQ0kLB_MiTArpNAWHUT0id_dbXXLu9UpPhRfN@mail.gmail.com>
 <20110302144322.GJ3319@htj.dyndns.org>
 <AANLkTimatMdmovtaouPRy9LVU75LuBOE-9H+LWhhm6qu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimatMdmovtaouPRy9LVU75LuBOE-9H+LWhhm6qu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Mar 02, 2011 at 04:16:50PM +0100, Denys Vlasenko wrote:
> Assuming the program is run under simple debugger which
> resumes execution using PTRACE_CONT(sig) on signal delivery stops,
> with PTRACE_CONT(0) on ptrace stops,
> and doesn't do any PTRACE_CONT on job control stops,
> with your proposal the debugger will see and perform
> the following actions:
> 
> waitpid...
>   <------ kill -STOP 16382
> waitpid returns WSTOPPED, WSTOPSIG = SIGSTOP
> ptrace(PTRACE_GETSIGINFO) doesn't fail (=> it's signal delivery)
> ptrace(PTRACE_CONT, SIGSTOP)
> waitpid returns WSTOPPED, WSTOPSIG = SIGSTOP
> ptrace(PTRACE_GETSIGINFO) fails (=> it's job control stop)
> waitpid...
>   <------ kill -ABRT 16382
> ...debugger doesn't wake up...
>   <------ kill -WINCH 16382
> ...debugger doesn't wake up...
>   <------ kill -CONT 16382
> waitpid returns WSTOPPED, WSTOPSIG = SIGTRAP (it's a ptrace-stop)
> ptrace(PTRACE_CONT, 0)
> waitpid returns WSTOPPED, WSTOPSIG = SIGWINCH
> ptrace(PTRACE_CONT, SIGWINCH)
> waitpid returns WSTOPPED, WSTOPSIG = SIGCONT
> ptrace(PTRACE_CONT, SIGCONT)
> waitpid returns WSTOPPED, WSTOPSIG = SIGABRT
> ptrace(PTRACE_CONT, SIGABRT)
> 
> Correct?

Yeah, seems correct to me.

Thanks.

-- 
tejun
