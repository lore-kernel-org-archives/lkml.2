Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0C3FrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 01:47:06 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:47553 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990Ab0C3FrE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 01:47:04 -0400
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
In-Reply-To: <1269414437.3355.6.camel@localhost>
References: <1268399863.3407.15.camel@localhost>
	 <4BA7773A.5080206@linux.intel.com> <1269361716.3475.1.camel@localhost>
	 <201003231757.51259.trenn@suse.de>  <4BA8F34C.9040401@linux.intel.com>
	 <1269414437.3355.6.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 07:46:55 +0200
Message-ID: <1269928015.3384.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 24.03.2010, 08:07 +0100 schrieb Robert Schöne:
> Am Dienstag, den 23.03.2010, 09:58 -0700 schrieb Arjan van de Ven:
> > On 3/23/2010 9:57, Thomas Renninger wrote:
> > > On Tuesday 23 March 2010 17:28:36 Robert SchÃ¶ne wrote:
> > >> Am Montag, den 22.03.2010, 06:57 -0700 schrieb Arjan van de Ven:
> > >>> On 3/22/2010 0:04, Robert SchÃ¶ne wrote:
> > >>>> Am Sonntag, den 21.03.2010, 17:42 -0700 schrieb Arjan van de Ven:
> > >>>>> On 3/20/2010 14:37, Thomas Renninger wrote:
> > >>>>>
> > >>>>>> It also seem to be (hopefully) a minor feature for timechart, so this should
> > >>>>>> not hurt that much (yet).
> > >>>>>
> > >>>>> It's actually a major feature for timechart, and one of the key things I and a bunch of others
> > >>>>> inside Intel use timechart for.
> > >>>>>
> > >>>> It's a major feature for us too.
> > >>>> I suppose, the cpufreq_notify_transition calls are correct (meaning
> > >>>> being called for all related cpus) for every driver. So there's still
> > >>>> the option to include it in the POST_CHANGE section of this function.
> > >>>> Could this be okay for the both of you?
> > >>>
> > >>> post change would work... that gets frequency afaik..
> > >> Are you ok with this too, Thomas?
> > > You mean hooking it into cpufreq_stat_notifier_trans() in
> > > drivers/cpufreq/cpufreq_stats.c?
> > 
> > no
> > 
> > 
> > hooking into the post frequency change callback that gets done..
> > which is guaranteed to be on the right cpu afaics.
> > 
> I don't see where this would be guaranteed. So I'd be fine with
> a) adding it to
> cpufreq.c/cpufreq_notify_transition/cpufreq_notify_transition
> 
> b) adding an item to the cpufreq_transition_notifier_list
> 
> c) adding it to cpufreq_stats.c/cpufreq_stat_notifier_trans
> 
> which would imply the usage of smp_call_function_single(...)
> 
I really want to keep this diskussion alive until there's a soultion we
can all agree.
So Arjan and Thomas, are there any comments/preferences to the proposed
options?


