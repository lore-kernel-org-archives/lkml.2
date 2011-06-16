Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1FPIig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:38:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35375 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1FPIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XqtopDow6+Ya5fLuMJMR3SquVw3AbQ/8Hk/8HtN9Puh/M4Nk0Vxb9Od/6alqfsOaIp
         6WEtMhHWXGAOQGo2MkC0caSiay05/0rKRvQ26vte8TxGJfRejEVOwXx7/pVoxTS4PKjG
         NP7niBAyKVcAxp26cRhljrJHj9AumoT/ZdylM=
Date: Thu, 16 Jun 2011 10:38:28 +0200
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#4
Message-ID: <20110616083828.GJ8141@htj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <BANLkTik5hV8dnyspyGz8YAAdtoQNQDyOSw@mail.gmail.com>
 <20110603012445.GA14872@mtj.dyndns.org>
 <201106031125.16071.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106031125.16071.pedro@codesourcery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pedro.  Sorry about late reply.

On Fri, Jun 03, 2011 at 11:25:15AM +0100, Pedro Alves wrote:
> Some archs started encoding some of that stuff on SIGTRAPs si_code.
> E.g., on a ppc box I got here, I see:
> 
> /* `si_code' values for SIGTRAP signal.  */
> enum
> {
>   TRAP_BRKPT = 1,               /* Process breakpoint.  */
> # define TRAP_BRKPT     TRAP_BRKPT
>   TRAP_TRACE                    /* Process trace trap.  */
> # define TRAP_TRACE     TRAP_TRACE
> };

Yeap, several archs seem to have grown their own tricks.

> It'd be _very_ useful for x86 (and others) to have
> something like TRAP_BRKPT for int3.  Both for ptracers
> and in-process self debuggers.
> 
> I'd be super happy to be told we have that already
> in recent kernels and I missed it.  :-)

Unfortunately, AFAICS, x86 doesn't have it nor is there a generic
mechanism, but this should be solvable without disrupting existing
users.

Thanks.

-- 
tejun
