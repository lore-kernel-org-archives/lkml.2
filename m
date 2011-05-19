Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab1ESMH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:07:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36324 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1ESMH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PLCce8N1M2arCdl4xFLaJqEO9aXpQdvCM/mev8oQOi4u94Yki8RuvWgNrA5AvFEdcI
         4eFCRZ9arM0HN8J1sioEkgP++xJBt6KnBJoJjNSd7boKr9Zh5/sNIxnKpkAzwMot0LWy
         ZOoadJsDluP97R8BNngqLfWYF6/DF9lEnOj14=
Date: Thu, 19 May 2011 14:07:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 04/10] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110519120723.GE627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-5-git-send-email-tj@kernel.org>
 <20110518183815.GA1064@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518183815.GA1064@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 18, 2011 at 08:38:15PM +0200, Oleg Nesterov wrote:
> On 05/16, Tejun Heo wrote:
> >
> > +	case PTRACE_INTERRUPT:
> > +		/*
> > +		 * Stop tracee without any side-effect on signal or job
> > +		 * control.  At least one trap is guaranteed to happen
> > +		 * after this request.  If @child is already trapped, the
> > +		 * current trap is not disturbed and another trap will
> > +		 * happen after the current trap is ended with PTRACE_CONT.
> > +		 *
> > +		 * The actual trap might not be PTRACE_EVENT_STOP trap but
> > +		 * the pending condition is cleared regardless.
> > +		 */
> > +		if (likely(child->ptrace & PT_SEIZED) &&
> > +		    lock_task_sighand(child, &flags)) {
> > +			child->jobctl |= JOBCTL_TRAP_STOP;
> 
> The same race with do_signal_stop() afaics.

I didn't understand that one, so you'll need to elaborate.

> Otherwise looks fine to me. Compared to V1, personally I like the new
> behaviour more. PTRACE_INTERRUPT and PTRACE_SEIZE do the same.

Great. :)

Thanks.

-- 
tejun
