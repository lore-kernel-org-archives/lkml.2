Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab2DJUdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:33:51 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:52952 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab2DJUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:33:50 -0400
Date: Tue, 10 Apr 2012 22:33:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v4 2/4] tools: Add a toplevel Makefile
Message-ID: <20120410203348.GB28293@merkur.ravnborg.org>
References: <1334071240-28692-1-git-send-email-bp@amd64.org> <1334071240-28692-3-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334071240-28692-3-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 05:20:38PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add a Makefile with all the targets under tools/.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  tools/Makefile |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 tools/Makefile
> 
> diff --git a/tools/Makefile b/tools/Makefile
> new file mode 100644
> index 000000000000..e93b8ec3d250
> --- /dev/null
> +++ b/tools/Makefile
> @@ -0,0 +1,31 @@
> +include scripts/Makefile.include
> +
> +perf firewire lguest usb virtio vm: FORCE
> +	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
> +
> +cpupower: FORCE
> +	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
> +
> +turbostat x86_energy_perf_policy: FORCE
> +	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
> +
> +selftests: FORCE
> +	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
> +
> +firewire_clean lguest_clean perf_clean vm_clean usb_clean virtio_clean:
> +	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
> +
> +cp_clean:
> +	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
> +
> +turbostat_clean x86_energy_perf_policy_clean:
> +	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
> +
> +selftests_clean:
> +	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
> +
> +clean: cp_clean firewire_clean lguest_clean perf_clean selftests_clean \
> +		turbostat_clean usb_clean virtio_clean \
> +		x86_energy_perf_policy_clean
> +
> +.PHONY: FORCE

Things would be much simpler is all tools were adjusted to:
a) the subdir they live in is the make target name
b) each tool has three mandatory targets:
 1) default target => build the tool
 2) clean
 3) install

I can see that with the layout today you cannot
distingush between the various targets below power.
But the current solutions is not scaleable nor maintainable.

Even if you cannot fix power/* then testing looks easy.

But all that can always to improved and consolidated later.

	Sam
