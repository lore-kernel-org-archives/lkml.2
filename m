Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2FZLBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 07:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab2FZLBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 07:01:33 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] acpi, cpuidle: Register with cpuidle even if cpu is onlined after boot (beyond maxcpus)
Date: Tue, 26 Jun 2012 13:01:25 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <4FDB549F.1020002@linaro.org> <4FE987BB.4020508@linux.vnet.ibm.com> <4FE99206.8060109@linaro.org>
In-Reply-To: <4FE99206.8060109@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206261301.25550.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 26, 2012 12:42:14 PM Daniel Lezcano wrote:
> On 06/26/2012 11:58 AM, Srivatsa S. Bhat wrote:
> > On 06/26/2012 03:11 PM, Daniel Lezcano wrote:
> >> On 06/26/2012 11:29 AM, Thomas Renninger wrote:
...
> >>
> >> In this case, let's remove the intel_idle_cpu_init stuff in
> >> acpi_cpu_soft_notify, no ?
> >>
> > 
> > Why? And how would that help? The intel_idle_cpu_init() call is essential if intel_idle
> > driver is being used instead of acpi idle.
> 
> AFAIU, this code is not called after onlining a cpu greater than maxcpus
> and Thomas thinks that system with cpu hotplug at runtime are not sold.
Not 100% sure. Also the code paths to handle real CPU hotplug existed
already (via ACPI notify on the processor object) and did work.
I only fixed to correctly initialize idle states.

> The problem I see with this code is acpi and intel-idle are tied
> together now. I would like to break this dependency and use the notifier
> to handle the cpu hotplug directly in intel-idle.
> 
> It is hard to test my patch as there is not such system and maxcpus is
> not correctly handled here. I can use your patch to test my patch but
> anyway ... I am just asking if that would make sense to remove this
> portion of code instead :)
> 
> If we want to keep this code untouched, I can try my patch and maybe
> Thomas will agreed to test it also on a cpu-online-runtime-system if he
> has one.
But not this patch, we agreed it's not worth to look at:
"System exceeding maxcpus=x via cpu soft onlining does not initialize
power management on exceeding cores", right?

If you have a patch touching this, please point me to it.
I can have a look at it and if really necessary give it a test.

   Thomas
