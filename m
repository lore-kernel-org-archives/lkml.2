Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0CWQ54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:57:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:44962 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab0CWQ5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:57:55 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Robert =?utf-8?q?Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for Intel x86 CPUs)
Date: Tue, 23 Mar 2010 17:57:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
References: <1268399863.3407.15.camel@localhost> <4BA7773A.5080206@linux.intel.com> <1269361716.3475.1.camel@localhost>
In-Reply-To: <1269361716.3475.1.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003231757.51259.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010 17:28:36 Robert Schöne wrote:
> Am Montag, den 22.03.2010, 06:57 -0700 schrieb Arjan van de Ven:
> > On 3/22/2010 0:04, Robert Schöne wrote:
> > > Am Sonntag, den 21.03.2010, 17:42 -0700 schrieb Arjan van de Ven:
> > >> On 3/20/2010 14:37, Thomas Renninger wrote:
> > >>
> > >>> It also seem to be (hopefully) a minor feature for timechart, so this should
> > >>> not hurt that much (yet).
> > >>
> > >> It's actually a major feature for timechart, and one of the key things I and a bunch of others
> > >> inside Intel use timechart for.
> > >>
> > > It's a major feature for us too.
> > > I suppose, the cpufreq_notify_transition calls are correct (meaning
> > > being called for all related cpus) for every driver. So there's still
> > > the option to include it in the POST_CHANGE section of this function.
> > > Could this be okay for the both of you?
> > 
> > post change would work... that gets frequency afaik..
> Are you ok with this too, Thomas?
You mean hooking it into cpufreq_stat_notifier_trans() in
drivers/cpufreq/cpufreq_stats.c?
That sounds like the right approach.

But what assures that this is executed on the correct cpu, which seem
to be necessary with the current trace function?

   Thomas
