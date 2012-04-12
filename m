Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab2DLXNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:13:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64715 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab2DLXNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204122142180.2542@ionos>
References: <1334155379-18088-1-git-send-email-jkacur@redhat.com>
	<alpine.LFD.2.02.1204122142180.2542@ionos>
Date: Fri, 13 Apr 2012 01:13:38 +0200
X-Google-Sender-Auth: _qwObVQa7li0aqwvKcXviRNZFk8
Message-ID: <CAONaPpGwD6DK8BcTN0BOybx-kLPBEHpMKitohLN9UVtRRYpaZg@mail.gmail.com>
Subject: Re: [PATCH] rcutree: Fix v3.4-rc2-rt2 build break
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 9:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, 11 Apr 2012, John Kacur wrote:
>
> > Fix build break of the following types.
> >
> > linux-rt/kernel/rcutree_plugin.h: In function
> > ‘print_cpu_stall_fast_no_hz’:
> > linux-rt/kernel/rcutree_plugin.h:2195: error: ‘rcu_idle_gp_timer’
> > undeclared (first use in this function)
> > linux-rt/kernel/rcutree_plugin.h:2195: error: (Each undeclared
> > identifier is reported only once
> > linux-rt/kernel/rcutree_plugin.h:2195: error: for each function it
> > appears in.)
> >
> > The build break only occurs with the PREEMPT_RT_FULL patch applied,
> > however
> > the patch is meant to go upstream and be applied to v3.4-rc2 as well
> > because
> > it makes the code more legible there, and will reduce the number of
> > places
> > where #ifdef PREEMPT_RT_FULL is required should that go upstream
> > someday.
>
> -ENOPARSE
>
> I really have no idea what the patch is solving and which particular
> combination of config items is causing the above.

The config combination that causes a build break is

CONFIG_RCU_FAST_NO_HZ
CONFIG_PREEMPT_RT_FULL
CONFIG_RCU_CPU_STALL_INFO

The patch does the following

#if !defined(CONFIG_RCU_FAST_NO_HZ) || defined(CONFIG_PREEMPT_RT_FULL
        The patch moves the skeleton versions of the functions to this section
#else
        Versions of the functions that were causing a build break.
#endif

>
> If you think that the patch should go upstream then please send a
> separate one with a changelog which explains the simplifcation.

Applying the patch upstream causes no functional changes there.
I can try resubmitting a patch for upstream with a clearer changelog.
Or I perhaps I should dig deeper and try to simplify more for
upstream, but this is the simplest way I saw to fix the build break
for rt

>
> I agree that this ifdef maze can do with simplification, but providing
> a changelog which tells nothing at all does not make it easier to grok
> the problem and understand what's simplified.
