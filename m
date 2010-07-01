Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0GAEoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 00:44:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41246 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0GAEoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 00:44:09 -0400
Date: Wed, 30 Jun 2010 21:44:01 -0700
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
Message-ID: <20100701044401.GY4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
 <20100630073158.GA4453@infradead.org>
 <alpine.LRH.2.00.1007011057520.24202@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1007011057520.24202@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Thu, Jul 01, 2010 at 11:39:01AM +1000, James Morris wrote:
> On Wed, 30 Jun 2010, Christoph Hellwig wrote:
> > Err, no.  This is just a very clear sign that your ptrace restrictions
> > were completely wrong to start with and break applications left, right
> > and center.  Just get rid of it instead of letting workarounds for your
> > bad design creep into the core kernel and applications.
> 
> Indeed, I wasn't aware that there were further aspects to this -- I 
> thought it was a relatively simple case of restricting a problematic OS 
> feature for heavily locked down systems.

That's certainly my intent, but PTRACE is kind of a nasty beast.

> This is getting more complicated, with fine-grained security policy now 
> being introduced, also with the need to modify applications.

Well, I'm trying to solve what I think is a core problem with PTRACE -- it
is too permissive.  I'm happy to look at it from other angles if it doesn't
make sense for this kind of thing to live in Yama.  I'm already very happy
with the existing restrictions available in Yama.

> There are several existing LSMs with the ability to control ptrace, but as 
> part of a system-wide, coherent, analyzable policy -- often in support of 
> specific security models for which there is concrete user demand and 
> benefit.

Sure.  I am curious, though, is there a way for SELinux (or maybe Smack,
since it has more dynamic labels) to declare this kind of on-runtime PTRACE
relationship?  Maybe I overlooked some options for this.  I didn't see any
way for the kernel to intuit the relationship without the tracee
specifically declaring which process could PTRACE it, though.  Regardless
of the method, I think userspace changes would be needed for this kind of
thing.  I spent a little time discussing this within Ubuntu[1].

> If LSMs need to call into common code in Yama, or even do lightweight 
> chaining, that's one thing, but for Yama to evolve into yet another 
> standalone security scheme, is something entirely different.

I still think simple chaining is the way to go.  I want to review the
earlier discussions first (I think Serge said it was in 2004ish?) before I
write up anything.  There is, I think, one sticking point, which is
/proc/self/attr/current, but beyond that, I think some simple
reorganization of LSM initialization routines and a list that security_*
walks would be sufficient.

Thanks,

-Kees

[1] https://lists.ubuntu.com/archives/ubuntu-devel/2010-June/030939.html

-- 
Kees Cook
Ubuntu Security Team
