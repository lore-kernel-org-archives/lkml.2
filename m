Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab0CTVh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 17:37:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:59947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab0CTVhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 17:37:54 -0400
From: Thomas Renninger <trenn@suse.de>
To: Robert =?utf-8?q?Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for Intel x86 CPUs)
Date: Sat, 20 Mar 2010 22:37:56 +0100
User-Agent: KMail/1.9.10
Cc: Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
References: <1268399863.3407.15.camel@localhost> <201003182143.22929.trenn@suse.de> <1268985679.3395.47.camel@localhost>
In-Reply-To: <1268985679.3395.47.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003202237.57477.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This wrapper would make things easier of course, since one might add the
> same line for every driver
...
It's simply broken and can't be fixed without chaninging the whole concept.
power_frequency_events() must not only pass the cpu, but a cpumask also for 
acpi-cpufreq.
If you look at SW_ANY SW_ALL (or similar, I can't look at code right now) 
parts, acpi-cpufreq can change the frequency for several cores with one MSR 
write.
AFAIK this is for example the recommended way for Dunnington (6 cores).
So the collected data can be totally wrong.
Better remove this before others also start to use it.
It also seem to be (hopefully) a minor feature for timechart, so this should 
not hurt that much (yet).

     Thomas
