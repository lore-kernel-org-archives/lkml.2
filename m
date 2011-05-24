Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1EXJuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:50:09 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:57182 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1EXJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:50:07 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Tue, 24 May 2011 10:49:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-28-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105201027.36688.pedro@codesourcery.com> <20110520093111.GG31426@htj.dyndns.org>
In-Reply-To: <20110520093111.GG31426@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241049.58921.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 10:31:11, Tejun Heo wrote:
> On Fri, May 20, 2011 at 10:27:35AM +0100, Pedro Alves wrote:
> > Okay, good to hear that.  Looks like the tracer can do:
> > 
> >  SEIZE,execve,SETOPTS,'readlink /proc/pid/exe'
> > 
> > and pretend it SEIZED after the execve.
> 
> Yeap, and I was trying to say that if tracer and tracee are running on
> different CPUs, the order between SEIZE and execve isn't even well
> defined (sans the nasty automatic SIGTRAP).

I see, indeed, thanks.

A couple interface questions that just crossed my mind:

 - on a fork/vfork/clone, if PTRACE_EVENT_FORK|VFORK|CLONE have been
   enabled, will the tracer still see the new child stop with a
   SIGSTOP, or will it see a PTRACE_EVENT_INTERRUPT?

 - is PTRACE_INTERRUPT on PTRACE_TRACEME-traced-child planed to
   be allowed (for convenience)?
   A PTRACE_O_TRACEINTERRUPT, or some such PTRACE_SETOPTIONS
   option might be necessary to get PTRACE_EVENT_INTERRUPT instead
   of SIGSTOP in the point above.

-- 
Pedro Alves
