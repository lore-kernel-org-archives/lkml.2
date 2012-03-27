Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2C0HbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:31:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab2C0HbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:31:13 -0400
Message-ID: <4F716CB5.5010303@redhat.com>
Date: Tue, 27 Mar 2012 09:31:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop> <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com> <4F6EEEC1.4030608@redhat.com> <1332708684.2882.24.camel@pasglop> <4F703F5E.8030700@redhat.com> <20120326162101.GA524@gmail.com>
In-Reply-To: <20120326162101.GA524@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 06:21 PM, Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
> > Say a fix comes in which needs to be mainlined during -rc.  So 
> > I put it in some other branch, to be sent off to Linus in a 
> > few days after maturing a little.  Meanwhile developers see an 
> > incomplete tree, since that patch is not in it.
> > 
> > Once Linus pulls, I can merge it back (or even before, if I'm 
> > reasonably certain it's not going to change), but it leaves a 
> > history of unneeded merges.  Or we can do throwaway merges 
> > like tip.git.
>
> We don't do throwaway merges in the -tip development branches 
> themselves, i.e. in tip:sched/core, tip:perf/core, 
> tip:timers/core, etc.
>
> When a fix goes into tip:sched/urgent then until Linus merges it 
> it's not in tip:sched/core. 99% of the fixes don't *have to* go 
> into sched/core straight away.
>
> In the odd case where there's some dependency, we can manually 
> merge it into tip:sched/core ahead of Linus pulling into an -rc. 
> Those rare merges are not a problem, and I explain the reason in 
> the merge commit itself.
>
> If you look at:
>
>  gll v3.2..v3.3 | grep -E '/urgent.*/core'
>
> you'll see that I only had to do it once in the previous cycle:
>
>  d6c1c49de577 Merge branch 'perf/urgent' into perf/core
>
> and the changelog explains the background:
>
> Merge reason: Add these cherry-picked commits so that future changes
>               on perf/core don't conflict.
>
> it was a rare, oddball situation where we cherry-picked 
> perf/core changes into perf/urgent. Extra merges are perfectly 
> fine in that case.
>
> The 'throwaway' tip:master branch you are probably referring to 
> is basically just a testing branch, a convenient merged tree of 
> the one dozen maintainer trees that are hosted in -tip. Since we 
> don't want to force Linus's hand of him being able to reject 
> individual trees we don't merge them properly - hence the 
> integrated tree is a throwaway tree in theory.
>
> In practice I tend to throw it away only once per cycle, around 
> -rc1, once all pending trees went to Linus. tip:master is not 
> used for any Git based contribution work - it's for testing, 
> it's for people who want to work with patches - the commits 
> themselves always go into persistent non-rebasing, append-only 
> Git trees.
>
> If we mess up bisectability we do a delta fix. When choosing 
> between somewhat better bisectability and a proper history that 
> others can rely on then proper history wins hands down.
>

Okay, we'll adopt a similar workflow for the future.

-- 
error compiling committee.c: too many arguments to function

