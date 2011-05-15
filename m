Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1EOO2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:28:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32856 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1EOO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ffLhsAIMSwupgwVYD3d8UjqbJwNwn7/SLddVixjEUKOJhGsN4pUcjgd+hc/A2w0NDH
         xAnZAgPGav3QfIKIdWIlnmSwWYErsJA5n0zNqf0nUHR7sGTLRchAyRQXFTH69TB4w61p
         pK52TyAT7mQrv609TZrczfbqcF97lo87kjiiw=
Date: Sun, 15 May 2011 16:28:27 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re:
 [PATCH 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110515142827.GF23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515140232.GB31855@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Sun, May 15, 2011 at 04:02:32PM +0200, Jan Kratochvil wrote:
> Or there should be some other way how to query the siginfo_t state
> fully transparently (*).
>
> (*) But if there exists such syscall it probably does not make sense to modify
>     anything by PTRACE_GETSIGINFO.

If there's a syscall which doesn't affect notification state, then we
need something which does clear it.  Either way, I suppose you're
saying we need both something which clears the notification and
something which doesn't.

> Imagine various LD_PRELOAD tools which try to wrap system/library calls and
> operate with ptrace while keeping it transparent for the original debugger.
> (I have a bunch of such libraries for testing gdb/strace/etc. written there.)
> 
> Also complicated debuggers with internal OO hierarchy would need to just wrap
> PTRACE_GETSIGINFO into an internal function to make it transparent for calls
> not intending to modify the debuggee state.

We can add a flag or new request for that but I don't know.  Those are
pretty fringe use cases and they don't even strictly require such
feature - Even for LD_PRELOAD, it can simply keep scheduling INTERRUPT
until the application calls the wrapped GETSIGINFO when it detects the
stopped state has changed.  It can be easily done from userland.

Thank you.

-- 
tejun
