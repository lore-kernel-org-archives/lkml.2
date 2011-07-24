Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1GXD3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:29:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47545 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1GXD3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:29:04 -0400
Date: Sun, 24 Jul 2011 04:28:58 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: cpufreq@vger.kernel.org, davej@redhat.com, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, mark.langsdorf@amd.com,
        andreas.herrmann3@amd.com
Subject: Re: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic
 overclocking
Message-ID: <20110724032858.GA25722@srcf.ucam.org>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
 <1311007062-2050-4-git-send-email-mjg@redhat.com>
 <4E2B8C35.7030304@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2B8C35.7030304@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 11:06:29PM -0400, Andy Lutomirski wrote:
> On 07/18/2011 12:37 PM, Matthew Garrett wrote:
> >One feature present in powernow-k8 that isn't present in acpi-cpufreq is
> >support for enabling or disabling AMD's core performance boost technology.
> >This patch adds that support to acpi-cpufreq, but also extends it to allow
> >Intel's dynamic acceleration to be disabled via the same interface. The
> >sysfs entry retains the cpb name for compatibility purposes.
> >
> >Signed-off-by: Matthew Garrett<mjg@redhat.com>
> >---
> >  drivers/cpufreq/acpi-cpufreq.c |  191 ++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 191 insertions(+), 0 deletions(-)
> >
> 
> How is this different from setting 3400000 vs 3401000 as the max
> freq? (I'm probably missing something about the way that Intel's
> turbo mode works.)

It's not really, it just means that there's a shared interface to 
achieve the same goal.

> >+	unsigned long val = 0;
> >+
> >+	ret = strict_strtoul(buf, 10,&val);
> >+	if (!ret&&  (val == 0 || val == 1)&&  cpb_supported)
> >+		cpb_toggle(val);
> 
> Shouldn't this set the flag only on policy->cpu (as opposed to all
> online cpus?)

It's effectively a per-package MSR rather than a per-thread or per-core 
one. We could make this per-package rather than system-wide, but I don't 
really know of any use cases that would benefit from the extra code. If 
anyone cares enough it could be added, but I'm a great believer in 
letting people come up with arguments for adding something before doing 
it...

> Also, you're missing a space before &&.

Think that's a cut and paste error. I'll fix it up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
