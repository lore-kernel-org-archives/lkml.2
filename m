Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0CQQgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:36:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0CQQgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:36:04 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for Intel x86 CPUs)
Date: Wed, 17 Mar 2010 17:36:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Robert =?iso-8859-15?q?Sch=F6ne?= <robert.schoene@tu-dresden.de>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
References: <1268399863.3407.15.camel@localhost> <201003161550.18102.trenn@suse.de> <4B9FB472.5060702@linux.intel.com>
In-Reply-To: <4B9FB472.5060702@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003171736.00550.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010 17:40:18 Arjan van de Ven wrote:
> On 3/16/2010 7:50, Thomas Renninger wrote:
> > Still, as this is totally broken:
> >     - by design ->  only one of a dozen cpufreq drivers is supported
> 
> the one I care about is supported.
And that's the problem, before it's not removed, you do not care to
provide/suggest a proper solution that could fit others as well.

> The others... anyone can add
> support for their favorite driver.
Or everyone can write his own debug facility for every driver...

As said, there already is a debug facility. If you need timings,
improve the existing interface, suggest how it could get connected
to the tracing facility or why you see problems doing so.

> > please submit my patch and remove this again until a proper
> > implementation is provided.

> how about not. it works right now,
It does not. Robert's fix (if he had taken the frequency) is correct.
That means you could get totally wrong values
when you put some load on the machine and the scheduler moves around
processes. You'd better compared your results with cpufreq_stats...
> and is in active use right now.
It's obviously not powertop, there I get some statistics on an AMD
machine as well. So where does it get used?

> feel free to add support to other drivers if you care about those....
It's easy to fix up acpi-cpufreq itself and implement this into
powernow-k8. Not sure about possible cpufreq drivers which can switch
frequency on cores without executing the code on this core. I expect
trace(_power_frequency) is not made for such?

I assume everybody who did work on cpufreq interfaces would have given
you a not-ack'ed or at least had asked the questions I did above.
People know you well and x86 maintainers just pushed it, I also doubt
you intentionally did not CC the cpufreq list.
But now things are broken and should get reverted.

Grmpfl, I can have a look at it, but not the next couple of days...

    Thomas
