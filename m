Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1GXDtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:49:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52466 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1GXDtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:49:39 -0400
Date: Sun, 24 Jul 2011 04:49:37 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: cpufreq@vger.kernel.org, davej@redhat.com, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, mark.langsdorf@amd.com,
        andreas.herrmann3@amd.com
Subject: Re: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic
 overclocking
Message-ID: <20110724034937.GA25873@srcf.ucam.org>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
 <1311007062-2050-4-git-send-email-mjg@redhat.com>
 <4E2B8E36.6030308@mit.edu>
 <20110724033313.GB25722@srcf.ucam.org>
 <CAObL_7Gis4YaSB+suFXxLmSchmJaEc6Jqv6aY6VvWynuEkRb5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7Gis4YaSB+suFXxLmSchmJaEc6Jqv6aY6VvWynuEkRb5A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 11:42:50PM -0400, Andrew Lutomirski wrote:
> On Sat, Jul 23, 2011 at 11:33 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > This complicates things a little, since right now we just write the
> > firmware's P state value directly into PERF_CTL. We'd need to add code
> > to acpi_cpufreq_target to make sure that it masked that bit off. It's a
> > little more awkward, but if we're being told not to do it by just
> > hitting the bit in MISC_ENABLE it's probably worth it. I'll try to
> > handle that this week.
> 
> This way may give the benefit of making it work per core instead of
> per package.  The manual is rather unclear on this point.

Being able to enter turbo mode typically requires coordination between 
the cores in order to ensure that the package remains within limits. The 
AMD implementation certainly disables their equivalent entirely if any 
core in the package has it disabled. I haven't verified that Intel 
behaviour is identical, but it wouldn't surprise me. I can try to check 
that.

> I actually have a use case for this.  I have a system that keeps a
> bunch of cores under moderate load.  I have one thread in particular
> that needs to be fast, and I'd like to disable boosting on the other
> cores to keep more thermal and power headroom available for the one
> thread that cares.

Are the other threads sufficiently opportunistic to use extra CPU power 
if it's available to them? You'll generally only get turbo if the other 
cores are in C6, so even if turbo is disabled on a specific core it'll 
probably prevent another core from entering turbo if anything's 
executing on it. You'd arguably want it to be able to get into turbo so 
it can hit C6 more quickly and let the other thread use the extra 
headroom.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
