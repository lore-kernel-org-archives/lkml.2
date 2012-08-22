Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2HVBAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 21:00:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab2HVBAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 21:00:14 -0400
From: Thomas Renninger <trenn@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 7/8] cpufreq: Remove support for hardware P-state chips from powernow-k8
Date: Wed, 22 Aug 2012 03:00:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: Andre Przywara <andre.przywara@amd.com>, cpufreq@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com> <503234FA.908@amd.com> <201208202249.16445.rjw@sisk.pl>
In-Reply-To: <201208202249.16445.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208220300.03512.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012 22:49:16 Rafael J. Wysocki wrote:
> On Monday, August 20, 2012, Andre Przywara wrote:
> > On 08/05/2012 11:33 PM, Rafael J. Wysocki wrote:
> > > On Thursday, July 26, 2012, Andre Przywara wrote:
...
> > 
> > If you insist, I can keep the code in powernow-k8, but it probably 
> > wouldn't receive any support anymore and would increase confusion on the 
> > user side.
> 
> I'm not afraid of that.  And as I said, you can just add info messages to
> powernow-k8 saying that the feature is deprecated and will be removed in the
> future and _then_ you actually _can_ remove it in the future (say, 2-3 major
> kernel releasew from now).

Full code duplication in powernow-k8 and acpi-cpufreq does not make sense
to me.
You would need extra logic that only the first is successfully loaded etc.
IMO this has more risk of introducing new bugs than any good.

A message like that might be useful though:
if (boot_cpu_has(X86_FEATURE_HW_PSTATE))
{
     printk("powernowk8 does not serve MSR based frequency switching anymore, use acpi-cpufreq instead\n");
     return -1;
}

This would show people with init scripts that try to load cpufreq drivers
manually that they are not needed anymore. acpi-cpufreq should have been
loaded automatically already and cpufreq should be active.

    Thomas
