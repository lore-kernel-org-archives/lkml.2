Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab1BDKxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:53:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53839 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1BDKxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pea+5ukxREwaSLQ2FXHC8VSo8z97pzuyMQPnN33PAJ1KzazZCQ29w/qlf+v8ilFT0C
         L3v7OqYNU2i8Ep6cxLPMic8QzgZnfsEf+HlT/ldAv2YFEHEsuU9a6xsq38IBFK1+51RN
         4CYZKTWw9INiRspQ6aFs3Wa5FUHu90vI6b/RQ=
Date: Fri, 4 Feb 2011 11:53:43 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110204105343.GA12133@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-11-git-send-email-tj@kernel.org>
 <20110203204122.GA26371@redhat.com>
 <20110203204154.GB26371@redhat.com>
 <20110203213640.1F516180995@magilla.sf.frob.com>
 <20110203214450.GA29496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203214450.GA29496@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg, Roland.

On Thu, Feb 03, 2011 at 10:44:50PM +0100, Oleg Nesterov wrote:
> On 02/03, Roland McGrath wrote:
> >
> > IMHO this sort of band-aid does not really help the overall situation.
> > It takes something that is intricate and fiddly and just fiddles it a
> > bit more.  Userland will still have to handle older kernels where this
> > behavior is not there.  If userland does anything that relies on this
> > new behavior, then it will have to try somehow to figure out which
> > kernel versions have which behavior and adapt, etc.
> 
> Absolutely agreed.
> 
> As I said, I am not sure this patch makes sense. I only sent it
> because I have to react to the bug report.
> 
> > When the old behaviors are unhelpful like this, I think it is really
> > better to add new mechanisms instead.
> 
> Agreed!
> 
> Can't resist, let me repeat... imho ptrace is unfixable ;)

Hmm... I can't reproduce the problem here, but isn't the problematic
part here the mixing of ptrace and group stop and sliently
transforming group stop into ptrace and ptracer consuming the usual
exit code instead of the ptrace specific one?

Also, I don't agree with the notion that doing something entirely new
would magically solve all the problems.  Improvements are achieved
through evolution.  For ptrace, the situation definitely is aggravated
by the use of wait and weird interaction with group stop, but the
interaction is inherently complex for debugging facility and most
problems won't automatically go away with new interface.

Actually, I think such approach is significantly harmful to
improvements of the existing code base.  Instead of encouraging
investigating the actual problems and making sensible tradeoffs, such
approach discourages making reasonable tradeoffs with the false
expectation that something in the future will magically solve the
problems.  In a lot of cases, there are no unicorns.  Proceeding
forward while managing damage at reasonable level is usually the right
way to go.

That said, well, there always are exceptions and maybe there are some
rainbow farting unicorns in the ptrace land.

Thanks.

-- 
tejun
