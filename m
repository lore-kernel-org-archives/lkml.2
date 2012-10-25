Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584Ab2JYJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:57:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964920Ab2JYJ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:57:21 -0400
Date: Thu, 25 Oct 2012 11:57:19 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Qiang Gao <gaoqiangscut@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: process hangs on do_exit when oom happens
Message-ID: <20121025095719.GA11105@dhcp22.suse.cz>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
 <20121019160425.GA10175@dhcp22.suse.cz>
 <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
 <CAKTCnzkMQQXRdx=ikydsD9Pm3LuRgf45_=m7ozuFmSZyxazXyA@mail.gmail.com>
 <CAKWKT+bYOf0cEDuiibf6eV2raMxe481y-D+nrBgPWR3R+53zvg@mail.gmail.com>
 <20121023095028.GD15397@dhcp22.suse.cz>
 <CAKWKT+b2s4E7Nne5d0UJwfLGiCXqAUgrCzuuZi6ZPdjszVSmWg@mail.gmail.com>
 <20121023101500.GE15397@dhcp22.suse.cz>
 <CAKTCnzkiabWK8tAORkhg6oW11VvXS-YqBwDzED_3=J1buhaQnQ@mail.gmail.com>
 <CAKWKT+ZahFTnPRJ4FCebxfcrcYEBf+PL9Wa_Foygep_gFst4_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKWKT+ZahFTnPRJ4FCebxfcrcYEBf+PL9Wa_Foygep_gFst4_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-10-12 11:44:17, Qiang Gao wrote:
> On Wed, Oct 24, 2012 at 1:43 AM, Balbir Singh <bsingharora@gmail.com> wrote:
> > On Tue, Oct 23, 2012 at 3:45 PM, Michal Hocko <mhocko@suse.cz> wrote:
> >> On Tue 23-10-12 18:10:33, Qiang Gao wrote:
> >>> On Tue, Oct 23, 2012 at 5:50 PM, Michal Hocko <mhocko@suse.cz> wrote:
> >>> > On Tue 23-10-12 15:18:48, Qiang Gao wrote:
> >>> >> This process was moved to RT-priority queue when global oom-killer
> >>> >> happened to boost the recovery of the system..
> >>> >
> >>> > Who did that? oom killer doesn't boost the priority (scheduling class)
> >>> > AFAIK.
> >>> >
> >>> >> but it wasn't get properily dealt with. I still have no idea why where
> >>> >> the problem is ..
> >>> >
> >>> > Well your configuration says that there is no runtime reserved for the
> >>> > group.
> >>> > Please refer to Documentation/scheduler/sched-rt-group.txt for more
> >>> > information.
> >>> >
> >> [...]
> >>> maybe this is not a upstream-kernel bug. the centos/redhat kernel
> >>> would boost the process to RT prio when the process was selected
> >>> by oom-killer.
> >>
> >> This still looks like your cpu controller is misconfigured. Even if the
> >> task is promoted to be realtime.
> >
> >
> > Precisely! You need to have rt bandwidth enabled for RT tasks to run,
> > as a workaround please give the groups some RT bandwidth and then work
> > out the migration to RT and what should be the defaults on the distro.
> >
> > Balbir
> 
> 
> see https://patchwork.kernel.org/patch/719411/

The patch surely "fixes" your problem but the primary fault here is the
mis-configured cpu cgroup. If the value for the bandwidth is zero by
default then all realtime processes in the group a screwed. The value
should be set to something more reasonable.
I am not familiar with the cpu controller but it seems that
alloc_rt_sched_group needs some treat. Care to look into it and send a
patch to the cpu controller and cgroup maintainers, please?

-- 
Michal Hocko
SUSE Labs
