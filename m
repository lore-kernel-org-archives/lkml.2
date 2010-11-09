Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0KIXdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:33:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10714 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab0KIXdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:33:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GP0f74i/Z3X9OW4blxC6Pa8WYRVi8CFfnHGk3GD6oDsmefEBLh4NtvfdX1LCYDOUv+
         glQDjSqPu8B9XMp5/tCw==
Date: Tue, 9 Nov 2010 15:33:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101109105801.BC30.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011091523370.26837@chino.kir.corp.google.com>
References: <20101101030353.607A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011011232120.6822@chino.kir.corp.google.com> <20101109105801.BC30.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, KOSAKI Motohiro wrote:

> > > > The new tunable added in 2.6.36, /proc/pid/oom_score_adj, is necessary for 
> > > > the units that the badness score now uses.  We need a tunable with a much 
> > > 
> > > Who we?
> > > 
> > 
> > Linux users who care about prioritizing tasks for oom kill with a tunable 
> > that (1) has a unit, (2) has a higher resolution, and (3) is linear and 
> > not exponential.  
> 
> No. Majority user don't care. You only talk about your case. Don't ignore
> end user.
> 

If they don't care, then they won't be using oom_adj, so you're point 
about it's deprecation is irrelevant.

Other users do want a more powerful userspace interface with a unit and 
higher resolution (I am one of them), there's no requirement that those 
users need to be in the majority.

> > Memcg doesn't solve this issue without incurring a 1% 
> > memory cost.
> 
> Look at a real.
> All major distributions has already turn on memcg. End user don't need
> to pay additional cost.
> 

Memcg also has a command-line disabling option to avoid incurring this 1% 
memory cost when you're not going to be using it.

> > No, it doesn't, and you completely and utterly failed to show a single 
> > usecase that broke as a result of this because nobody can currently use 
> > oom_adj for anything other than polarization.  Thus, there's no backwards 
> > compatibility issue.
> 
> No. I showed. 
> 1) Google code search showed some application are using this feature.
> 	http://www.google.com/codesearch?as_q=oom_adj&btnG=Search+Code&hl=ja&as_package=&as_lang=&as_filename=&as_class=&as_function=&as_license=&as_case=
> 

oom_adj isn't removed, it's deprecated.  These users are using a 
deprecated interface and have a few years to convert to using the new 
interface (if it ever is actually removed).

> 2) Not body use oom_adj other than polarization even though there are a few.
>    example, kde are using.
> 	http://www.google.com/codesearch/p?hl=ja#MPJuLvSvNYM/pub/kde/unstable/snapshots/kdelibs.tar.bz2%7CWClmGVN5niU/kdelibs-1164923/kinit/start_kdeinit.c&q=oom_adj%20kde%205
> 
> When you are talking polarization issue, you blind a real. Don't talk your dream.
> 

I don't understand what you're trying to say here, but the current users 
of oom_adj that aren't +15 or -16 (or OOM_DISABLE) are arbitrary based 
relative to other tasks such as +5, +10, etc.  They don't have any 
semantics other than being arbitrarily relative because it doesn't work in 
a linear way or with a scale.

> 3) udev are using this feature. It's one of major linux component and you broke.
> 
> http://www.google.com/codesearch/p?hl=ja#KVTjzuVpblQ/pub/linux/utils/kernel/hotplug/udev-072.tar.bz2%7CwUSE-Ay3lLI/udev-072/udevd.c&q=oom_adj
> 
> You don't have to break our userland. you can't rewrite or deprecate 
> old one. It's used! You can only add orthogonal new knob.
> 

That's incorrect, I didn't break anything by deprecating a tunable for a 
few years.  oom_adj gets converted roughly into an equivalent (but linear) 
oom_score_adj.

Unfortunately for your argument, you can't show a single example of a 
current oom_adj user that has a scientific calculation behind its value 
that is now broken on the linear scale.

> > Yes, I've tested it, and it deprecates the tunable as expected.  A single 
> > warning message serves the purpose well: let users know one time without 
> > being overly verbose that the tunable is deprecated and give them 
> > sufficient time (2 years) to start using the new tunable.  That's how 
> > deprecation is done.
> 
> no sense.
> 
> Why do their application need to rewrite for *YOU*? Okey, you will got
> benefit from your new knob. But NOBDOY use the new one. and People need
> to rewrite their application even though no benefit. 
> 
> Don't do selfish userland breakage!
> 

It's deprecated for a few years so users can gradually convert to the new 
tunable, it wasn't removed when the new one was introduced.  A higher 
resolution tunable that scales linearly with a unit is an advantage for 
Linux (for the minority of users who care about oom killing priority 
beyond the heuristic) and I think a few years is enough time for users to 
do a simple conversion to the new tunable.
