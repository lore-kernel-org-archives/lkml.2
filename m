Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab1ESQk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:40:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tZVsp+0UkSS8XOb4LxoYOpzj0yzKdjOOnSVL1Gavdt3aUbaZBzcuNkZDYNKRyJbfSt
         F3YNxhY5eMDsJwlQsykPnbTqAXHbPLvCOoehfQv1jMGG8fcuu5VLdtqcmsJy+TDGylIJ
         Vdpvj7WHJXkM5/iSNxSqwQjueZrds7C8izot0=
Date: Thu, 19 May 2011 18:40:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 07/10] ptrace: make group stop state visible via
 PTRACE_GETSIGINFO
Message-ID: <20110519164021.GN627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-8-git-send-email-tj@kernel.org>
 <20110519162741.GD17265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519162741.GD17265@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 06:27:41PM +0200, Oleg Nesterov wrote:
> On 05/16, Tejun Heo wrote:
> > @@ -585,6 +587,23 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
> >
> >  	error = 0;
> >  	*info = *child->last_siginfo;
> > +
> > +	/*
> > +	 * If reporting ptrace trap for a seized tracee, enable reporting
> > +	 * of info->si_pt_flags.
> > +	 */
> > +	if ((child->ptrace & PT_SEIZED) &&
> > +	    (info->si_code & __SI_MASK) == __SI_TRAP) {
> > +		/*
> > +		 * Report whether group stop is in effect w/ SI_STOPPED and
> > +		 * if so which signal caused it.
> > +		 */
> > +		if (sig->group_stop_count || sig->flags & SIGNAL_STOP_STOPPED) {
> 
> Cosmetic nit, you could declare "struct signal_struct *sig" here, under
> if (PT_SEIZED && __SI_TRAP).

Yeap, sure.  Will update.

> I must admit, personally I still dislike this new PTRACE_GETSIGINFO API...
> But I can't suggest anything better, so I am not going to argue.

It's not the prettiest, I agree, but it is more or less in line with
the rest of the interface, so...

Thanks.

-- 
tejun
