Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2JZAJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:09:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:38062 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab2JZAJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:09:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 2/2] cpufreq: governors: remove redundant code
Date: Fri, 26 Oct 2012 02:13:20 +0200
Message-ID: <1707056.POnhGSP0pg@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAKohpo=Nv6DfXqyv=v-1Eo=pvx25qyrQ2qs+pGqJvbJu2bwWaw@mail.gmail.com>
References: <32e5bed743cc6cc4e614291a7080299f5f0d0933.1350677395.git.viresh.kumar@linaro.org> <3245066.cWfgP9Ikey@vostro.rjw.lan> <CAKohpo=Nv6DfXqyv=v-1Eo=pvx25qyrQ2qs+pGqJvbJu2bwWaw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2012 08:59:11 AM Viresh Kumar wrote:
> On 25 October 2012 02:42, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday 24 of October 2012 21:43:46 Rafael J. Wysocki wrote:
> >> On Wednesday 24 of October 2012 11:37:13 Viresh Kumar wrote:
> >> > On 22 October 2012 14:16, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> > > On 20 October 2012 01:42, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> > >> Initially ondemand governor was written and then using its code conservative
> >> > >> governor is written. It used a lot of code from ondemand governor, but copy of
> >> > >> code was created instead of using the same routines from both governors. Which
> >> > >> increased code redundancy, which is difficult to manage.
> >> > >>
> >> > >> This patch is an attempt to move common part of both the governors to
> >> > >> cpufreq_governor.c file to come over above mentioned issues.
> >> > >>
> >> > >> This shouldn't change anything from functionality point of view.
> >> > >>
> >> > >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >> >
> >> > For everybody else, this patch is already pushed by Rafael in his linux-next
> >> > branch.
> >>
> >> Well, not yet, although I'm going to do that.
> >
> > Or I would if it still applied.  Unfortunately, though, it doesn't apply any
> > more to my linux-next branch due to some previous changes in it.
> >
> > Care to rebase?
> 
> Ahh.. I got confused by the following patch:
> 
> commit 83a73f712f2275033b2dc7f5c664988a1823ebc7
> Author: viresh kumar <viresh.kumar@linaro.org>
> Date:   Tue Oct 23 01:28:05 2012 +0200
> 
>     cpufreq: Move common part from governors to separate file, v2
> 
>     Multiple cpufreq governers have defined similar get_cpu_idle_time_***()
>     routines. These routines must be moved to some common place, so that all
>     governors can use them.
> 
>     So moving them to cpufreq_governor.c, which seems to be a better place for
>     keeping these routines.
> 
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> 
> Actually, i should i have replied on this patch (and i forgot). I
> wanted you to skip
> this patch, as the latest patch already had this change.
> 
> But now i see commits from others on cpufreq_governor.c file.
> 
> Hmm... So you can keep your tree as it is and apply the attached
> patch. It is the
> same patch getting discussed in this thread. Just rebased over your latest next.

I have applied this patch only because of the fixes on top of it.  It broke
kernel compliation due to some missing EXPORT_SYMBOL_GPLs in cpufreq_governor.c,
so I woulnd't have applied it otherwise.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
