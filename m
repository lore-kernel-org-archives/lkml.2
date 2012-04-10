Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab2DJUes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:34:48 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:41093 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2DJUeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:34:46 -0400
Date: Tue, 10 Apr 2012 22:34:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v4 3/4] tools: Add a help target
Message-ID: <20120410203444.GC28293@merkur.ravnborg.org>
References: <1334071240-28692-1-git-send-email-bp@amd64.org> <1334071240-28692-4-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334071240-28692-4-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 05:20:39PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> ... and make it the default one so that calling 'make' without arguments
> in the tools/ directory gives you the possible targets to build along
> with a short description of what they are.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  tools/Makefile |   26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/Makefile b/tools/Makefile
> index e93b8ec3d250..c7ed814e12cf 100644
> --- a/tools/Makefile
> +++ b/tools/Makefile
> @@ -1,5 +1,25 @@
>  include scripts/Makefile.include
>  
> +help:
> +	@echo 'Possible targets:'
> +	@echo ''
> +	@echo '  cpupower   - a tool for all things x86 CPU power'
> +	@echo '  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer'
> +	@echo '  lguest     - a minimal 32-bit x86 hypervisor'
> +	@echo '  perf       - Linux performance measurement and analysis tool'
> +	@echo '  selftests  - various kernel selftests'
> +	@echo '  turbostat  - Intel CPU idle stats and freq reporting tool'
> +	@echo '  usb        - USB testing tools'
> +	@echo '  virtio     - vhost test module'
> +	@echo '  vm         - misc vm tools'
> +	@echo '  x86_energy_perf_policy - Intel energy policy tool'
> +	@echo ''
> +	@echo 'Cleaning targets:'
> +	@echo ''
> +	@echo '  all of the above with the "_clean" string appended cleans'
> +	@echo '    the respective build directory.'
> +	@echo '  clean: a summary clean target to clean _all_ folders'
> +
>  perf firewire lguest usb virtio vm: FORCE
>  	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
>  
> @@ -15,7 +35,7 @@ selftests: FORCE
>  firewire_clean lguest_clean perf_clean vm_clean usb_clean virtio_clean:
>  	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
>  
> -cp_clean:
> +cpupower_clean:
>  	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean

Fold this into 2/4

>  
>  turbostat_clean x86_energy_perf_policy_clean:
> @@ -24,8 +44,8 @@ turbostat_clean x86_energy_perf_policy_clean:
>  selftests_clean:
>  	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
>  
> -clean: cp_clean firewire_clean lguest_clean perf_clean selftests_clean \
> -		turbostat_clean usb_clean virtio_clean \
> +clean: cpupower_clean firewire_clean lguest_clean perf_clean \
> +		selftests_clean turbostat_clean usb_clean virtio_clean \
>  		x86_energy_perf_policy_clean
Fold this into 2/4


	Sam
