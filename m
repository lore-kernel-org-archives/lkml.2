Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab1ESWsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:48:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54721 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ESWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AkbqMwRv62GwCOpKSMGita52B1wgvYEkzQFJIxBALUzcoTrCZlHl3Bxl/WpUAQxc61
         lOTPx3Bb3d3zsIeDuosCqwNURf2o8RVH4OOY08ZtzBFVOSI5uYIEoHSAxC1MX726u36x
         rn8ANAw1rb5FZm1LDONc6xQdbDWRAxJpHHCpw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for ptracer
Date: Fri, 20 May 2011 00:48:07 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <20110519165722.GP627@htj.dyndns.org> <20110519171327.GA19698@redhat.com>
In-Reply-To: <20110519171327.GA19698@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105200048.07942.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011 19:13, Oleg Nesterov wrote:
> On 05/19, Tejun Heo wrote:
> > On Thu, May 19, 2011 at 06:32:46PM +0200, Oleg Nesterov wrote:
> > > > +static void ptrace_trap_notify(struct task_struct *t)
> > > > +{
> > > > +	siginfo_t *si = t->last_siginfo;
> > > > +
> > > > +	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
> > > > +	assert_spin_locked(&t->sighand->siglock);
> > > > +
> > > > +	/*
> > > > +	 * @t is being ptraced and new SEIZE behavior is in effect.
> > > > +	 * Schedule sticky trap which will clear on the next GETSIGINFO.
> > > > +	 */
> > > > +	t->jobctl |= JOBCTL_TRAP_NOTIFY;
> > >
> > > This is also set by do_signal_stop(). Cleared by PTRACE_GETSIGINFO.
> > >
> > > How can this work? Doesn't this mean PTRACE_GETSIGINFO becomes mandatory
> > > before PTRACE_CONT? IOW, unless the tracee does PTRACE_GETSIGINFO to clear
> > > this bit, PTRACE_CONT just leads to another trap, no?
> >
> > Yes, group stop state change raises a sticky trap condition which is
> > cleared by GETSIGINFO.
> 
> Hmm. At least now I understand the meaining what "sticky" means in
> this discussion ;) I was confused.

I still don't see why is it needed. Userspace API doesn't require it.

Are you trying to solve/simplify something on the kernel side with it?

-- 
vda
