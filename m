Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1CUR0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:26:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50414 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1CUR0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s0b31hkXPZVVCR61ReBlRyK9EeOJR+J+HQEwM5YwJiiE97qhZrTizQzmPEodEnvgf2
         jbfmClwmoN+Pc/to/UHJszFUI7dGrjC1/OSSevO+S0POgAF8mDalmveuMipjywEm4KGb
         9JD1loVg604mSD36mpUUW42ZYo/APcLAe/WT4=
Date: Mon, 21 Mar 2011 18:20:26 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 4/8] job control: Allow access to job control events
 through ptracees
Message-ID: <20110321172026.GI12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-5-git-send-email-tj@kernel.org>
 <20110321163950.GA27409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321163950.GA27409@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 21, 2011 at 05:39:50PM +0100, Oleg Nesterov wrote:
> > @@ -1580,15 +1582,37 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
> >  			wo->notask_error = 0;
> >  	} else {
> >  		/*
> > +		 * If %current is ptracing @p, hide group stop/continued
> > +		 * state when looking at @p as the real parent; otherwise,
> > +		 * a single stop can be reported twice as group and ptrace
> > +		 * stops.
> > +		 *
> > +		 * If a ptracer wants to distinguish the two events for its
> > +		 * own children, it should create a separate task which
> > +		 * takes the role of real parent.
> > +		 */
> > +		if (likely(!ptrace) && task_ptrace(p) && p->parent == current)
> > +			return 0;
> 
> This doesn't look exactly right. Ignoring __WNOTHREAD, do_wait() should work
> the same way for every thread in parent/debugger's thread group. IOW, we
> should probably check same_thread_group(p->parent, p->real_parent) instead
> of "== current".

Alright, I'll update the test here and in the other patch which has
similar logic.

BTW, what are you planning about patch routing?  Are you gonna setup a
tree?

Thanks.

-- 
tejun
