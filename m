Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2GWStn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:49:43 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab2GWStl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:49:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH] [CPUFREQ] conservative: Initialise the cpu field of the this_dbs_info
Date: Mon, 23 Jul 2012 20:55:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1343028920-4712-1-git-send-email-amit.daniel@samsung.com> <201207231223.04620.rjw@sisk.pl> <CAK44p23wcPmK1c7PvobfuaFFaQ9FNDax9J-3iipgvEOCM5gWGQ@mail.gmail.com>
In-Reply-To: <CAK44p23wcPmK1c7PvobfuaFFaQ9FNDax9J-3iipgvEOCM5gWGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207232055.26506.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 23, 2012, Amit Daniel Kachhap wrote:
> On 23 July 2012 15:53, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Monday, July 23, 2012, Amit Daniel Kachhap wrote:
> > > This patch initialises the cpu field of this_dbs_info structure. This
> > > change is similar to existing ondemand governor.
> >
> > Why do you think the change is needed?
> >
> > Rafael
> >
> 
> I agree that this field is not used anywhere currently but I was trying to
> perform some experiments and then this un-initialised field caused issues
> so i thought of fixing this up.

So perhaps please write in the changelog that this is to keep governors
consistent with each other or something like this.  Without explanation it
looks pointless.

Thanks,
Rafael


> > > Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > > ---
> > >  drivers/cpufreq/cpufreq_conservative.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/cpufreq/cpufreq_conservative.c
> > b/drivers/cpufreq/cpufreq_conservative.c
> > > index 235a340..a1563d7 100644
> > > --- a/drivers/cpufreq/cpufreq_conservative.c
> > > +++ b/drivers/cpufreq/cpufreq_conservative.c
> > > @@ -504,6 +504,7 @@ static int cpufreq_governor_dbs(struct
> > cpufreq_policy *policy,
> > >                               j_dbs_info->prev_cpu_nice =
> > >
> > kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> > >               }
> > > +             this_dbs_info->cpu = cpu;
> > >               this_dbs_info->down_skip = 0;
> > >               this_dbs_info->requested_freq = policy->cur;
> > >
> > >
> >
> >
> 

