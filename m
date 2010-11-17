Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556Ab0KQGpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:45:12 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:36403 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259Ab0KQGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:45:11 -0500
Date: Wed, 17 Nov 2010 01:44:52 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] tools: add power/x86/turbostat - v2
In-reply-to: <20101116102916.GA4305@alberich.amd.com>
Message-id: <alpine.LFD.2.00.1011170126280.24426@x980>
References: <alpine.LFD.2.00.1010230116590.29399@localhost.localdomain>
 <alpine.LFD.2.00.1010240004180.23060@localhost.localdomain>
 <alpine.LFD.2.00.1010262312090.3209@localhost.localdomain>
 <alpine.LFD.2.00.1011151056380.2939@x980>
 <20101116102916.GA4305@alberich.amd.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Andreas Herrmann wrote:

> On Mon, Nov 15, 2010 at 11:01:05AM -0500, Len Brown wrote:
> > From: Len Brown <len.brown@intel.com>
> > 
> > turbostat displays actual processor frequency on modern
> > Intel processors.  Note that this capability depends on free-running
> > APERF and MPERF MSRs, which were cleared by the acpi_cpufreq
> > driver up through Linux-2.6.29.
> 
> Why isn't cpufreq-aperf sufficient for showing the actual frequency?
> The tool can handle both AMD and Intel CPUs.

Looking over its source code, I don't see any reason that cpufreq-aperf
wouldn't be sufficient for showing actual frequency, were that your goal.
I hadn't heard of this tool until your note.  I complied it, but I guess
I'm too lazy to figure out why it didnt' run.
It seems somewhat elaborate as compared to the task at hand...

> There is a CPUID flag which can be checked for APERF/MPERF existence,
> no need to enforce a general vendor check like this:
> 
>   $ ./turbostat
>   CPUID: AuthenticAMD != GenuineIntel

turbostat isn't very interesting on systems that don't
have a reliable TSC or C-state residency MSRs.  AFAIK,
AMD has neither.  If you have information to the contrary
and can test it on AMD hardware, I'd be happy to enable AMD,
as I have neither.

> > On Intel Core i3/i5/i7 (Nehalem) and newer processors,
> > turbostat displays residency in idle power saving states.
> 
> Can't this be added to cpuidle-info (see branch cpupowerutils in
> git://git.kernel.org/pub/scm/utils/kernel/cpufreq/cpufrequtils.git)?

I suppose it could if somebody were in need of a hobby.
However, if you want a big tool in this space,
you'd probably be better off running powertop2,
which will incorporate what turbostat does, and more.

> BTW, gcc v4.4 throws several warnings when compiling your
> code:

thanks, I'll fix these.

cheers,
Len Brown, Intel Open Source Technology Center
