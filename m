Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0CRUnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:43:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0CRUnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:43:31 -0400
From: Thomas Renninger <trenn@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for Intel x86 CPUs)
Date: Thu, 18 Mar 2010 21:43:22 +0100
User-Agent: KMail/1.9.10
Cc: Robert =?iso-8859-15?q?Sch=F6ne?= <robert.schoene@tu-dresden.de>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
References: <1268399863.3407.15.camel@localhost> <201003171736.00550.trenn@suse.de> <4BA10642.8070208@linux.intel.com>
In-Reply-To: <4BA10642.8070208@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003182143.22929.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 March 2010 05:41:38 pm Arjan van de Ven wrote:
> On 3/17/2010 9:36, Thomas Renninger wrote:
> > On Tuesday 16 March 2010 17:40:18 Arjan van de Ven wrote:
> >> On 3/16/2010 7:50, Thomas Renninger wrote:
> >>> Still, as this is totally broken:
> >>>      - by design ->   only one of a dozen cpufreq drivers is supported
> >>
> >> the one I care about is supported.
> >
> > And that's the problem, before it's not removed, you do not care to
> > provide/suggest a proper solution that could fit others as well.
>
> why don't you provide the others then?
Is it possible somehow to provide a kind of wrapper/backup function:
trace_power_frequency_cpu(POWER_PSTATE, frequency, cpu);
or another trace interface with eventually some more overhead?
Then it should be easy to support all drivers.
Otherwise you'll for example miss the pcc driver which supports
latest/upcoming Intel CPUs and which does IO based switching which needs not
to run on the cpu that gets switched.

     Thomas
