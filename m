Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab0KPK3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:29:23 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55088 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab0KPK3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:29:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=gfBw6yKkDMNnsWaZB3fvwshnk3JdoiGg4nnohp+RO7v7aBkUcySU54w9T9XCdVcj04
         o4yZOLaXxFv+lNee8FQ+2TNmzqqgI9z2Fqc3odNHhxy2mqC9XH3kixa8K1UACXuR46u2
         MoR3apWgcUNTr433hj38mkXwFuRFHMpzxqUqw=
Date: Tue, 16 Nov 2010 11:29:16 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] tools: add power/x86/turbostat - v2
Message-ID: <20101116102916.GA4305@alberich.amd.com>
References: <alpine.LFD.2.00.1010230116590.29399@localhost.localdomain>
 <alpine.LFD.2.00.1010240004180.23060@localhost.localdomain>
 <alpine.LFD.2.00.1010262312090.3209@localhost.localdomain>
 <alpine.LFD.2.00.1011151056380.2939@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1011151056380.2939@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:01:05AM -0500, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> turbostat displays actual processor frequency on modern
> Intel processors.  Note that this capability depends on free-running
> APERF and MPERF MSRs, which were cleared by the acpi_cpufreq
> driver up through Linux-2.6.29.

Why isn't cpufreq-aperf sufficient for showing the actual frequency?
The tool can handle both AMD and Intel CPUs.

There is a CPUID flag which can be checked for APERF/MPERF existence,
no need to enforce a general vendor check like this:

  $ ./turbostat
  CPUID: AuthenticAMD != GenuineIntel

> On Intel Core i3/i5/i7 (Nehalem) and newer processors,
> turbostat displays residency in idle power saving states.

Can't this be added to cpuidle-info (see branch cpupowerutils in
git://git.kernel.org/pub/scm/utils/kernel/cpufreq/cpufrequtils.git)?

BTW, gcc v4.4 throws several warnings when compiling your
code:

linux-2.6/tools/power/x86/turbostat $ make
cc -Wall    turbostat.c   -o turbostat
turbostat.c: In function ‘get_msr’:
turbostat.c:234: warning: implicit declaration of function ‘pread’
turbostat.c:237: warning: format ‘%x’ expects type ‘unsigned int’, but argument 4 has type ‘off_t’
turbostat.c:237: warning: format ‘%d’ expects type ‘int’, but argument 5 has type ‘ssize_t’
turbostat.c: In function ‘print_counters’:
turbostat.c:368: warning: unused variable ‘i’
turbostat.c: In function ‘compute_average’:
turbostat.c:508: warning: unused variable ‘i’
turbostat.c: In function ‘insert_cpu_counters’:
turbostat.c:642: warning: unused variable ‘next’
turbostat.c: In function ‘re_initialize’:
turbostat.c:747: warning: implicit declaration of function ‘for_all_cpus’
turbostat.c: In function ‘turbostat_loop’:
turbostat.c:779: warning: unused variable ‘retval’
turbostat.c: In function ‘check_cpuid’:
turbostat.c:868: warning: format ‘%.4s’ expects type ‘char *’, but argument 3 has type ‘unsigned int *’
turbostat.c:868: warning: format ‘%.4s’ expects type ‘char *’, but argument 4 has type ‘unsigned int *’
turbostat.c:868: warning: format ‘%.4s’ expects type ‘char *’, but argument 5 has type ‘unsigned int *’
turbostat.c:870: warning: implicit declaration of function ‘strncmp’
turbostat.c: At top level:
turbostat.c:912: warning: return type defaults to ‘int’
turbostat.c: In function ‘dir_filter’:
turbostat.c:957: warning: implicit declaration of function ‘isdigit’
turbostat.c: In function ‘turbostat_init’:
turbostat.c:1004: warning: unused variable ‘i’
turbostat.c: In function ‘fork_it’:
turbostat.c:1038: warning: implicit declaration of function ‘waitpid’
turbostat.c: In function ‘usage’:
turbostat.c:915: warning: control reaches end of non-void function
turbostat.c: In function ‘compute_delta’:
turbostat.c:401: warning: ‘i’ may be used uninitialized in this function


Regards,
Andreas
