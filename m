Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213Ab1GMKEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:04:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab1GMKEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:04:09 -0400
Date: Wed, 13 Jul 2011 12:04:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: fix ptrace_signal() && STOP_DEQUEUED
 interaction
Message-ID: <20110713100404.GG2872@htj.dyndns.org>
References: <20110707190301.GA25332@redhat.com>
 <20110707190324.GB25332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707190324.GB25332@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.  Sorry about the long delay.  Was lost somewhere else. :)

On Thu, Jul 07, 2011 at 09:03:24PM +0200, Oleg Nesterov wrote:
> Without the patch it hangs. After the patch SIGSTOP "injected" by the
> tracer is not ignored and stops the tracee.

I always felt the ability to 'inject' different signal there is rather
useless and prone to induce weird issues.  It would be better if
ptrace_signal() is part of signal delivery action after all the checks
so that the ptracer says whether to proceed with the action or not but
no more.  Well...

> So lets add STOP_DEQUEUED _before_ we report the signal. It has no effect
> unless sig_kernel_stop() == T after the tracer resumes us, and in the
> latter case the pending STOP_DEQUEUED means no SIGCONT in between, we
> should stop.

Anyways, yes, this seems to be a nice improvement but it looks very
weird (and difficult to comprehend) to be setting STOP_DEQUEUED
unconditionally in ptrace_signal().  Wouldn't it be better to flip the
flag so that we have CONT_RECEIVED before doing this?

Thanks.

-- 
tejun
