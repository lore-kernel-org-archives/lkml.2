Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1AUS7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:59:06 -0500
Received: from xenotime.net ([72.52.115.56]:56329 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752566Ab1AUS7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:59:05 -0500
Date: Fri, 21 Jan 2011 10:58:59 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jonathan McCune <jonmccune@cmu.edu>
Cc: linux-kernel@vger.kernel.org, tboot-devel@lists.sourceforge.net,
        trivial@kernel.org
Subject: Re: [PATCH, TRIVIAL] Add more explicit dependencies for
 CONFIG_INTEL_TXT
Message-Id: <20110121105859.7ea78d6c.rdunlap@xenotime.net>
In-Reply-To: <AANLkTi=0W3hZs6bsCwttg9BBgoQs0v-qVO5x5UPnNM+k@mail.gmail.com>
References: <AANLkTi=0W3hZs6bsCwttg9BBgoQs0v-qVO5x5UPnNM+k@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 13:39:19 -0500 Jonathan McCune wrote:

> This patch makes the documentation slightly more explicit about how to
> enable Intel TXT support in the kernel, and adds two dependencies to
> the relevant option in Kconfig.  Without this patch it is difficult to
> determine how to enable Intel TXT support without some knowledge of
> Kconfig.
> 
> Signed-off-by: Jonathan McCune <jonmccune@cmu.edu>
> 
> ---
>  Documentation/intel_txt.txt |    4 +++-
>  security/Kconfig            |    2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
> index 849de1a..8487f76 100644
> --- a/Documentation/intel_txt.txt
> +++ b/Documentation/intel_txt.txt
> @@ -196,7 +196,9 @@ Execution Technology (TXT)".  It is marked as
> EXPERIMENTAL and
>  depends on the generic x86 support (to allow maximum flexibility in
>  kernel build options), since the tboot code will detect whether the
>  platform actually supports Intel TXT and thus whether any of the
> -kernel code is executed.
> +kernel code is executed. The kernel option for enabling Intel TXT
> +support will only appear if its dependencies are also enabled.
> +These are CONFIG_DMAR and CONFIG_PCI_MSI.

Shouldn't that comment match the "depends on" line below??


>  The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
>  Authenticated Code Module.  It is specific to the chipset in the
> diff --git a/security/Kconfig b/security/Kconfig
> index 95accd4..5fd4e35 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -136,7 +136,7 @@ config SECURITY_PATH
> 
>  config INTEL_TXT
>  	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
> -	depends on HAVE_INTEL_TXT
> +	depends on HAVE_INTEL_TXT && EXPERIMENTAL && DMAR && ACPI
>  	help
>  	  This option enables support for booting the kernel with the
>  	  Trusted Boot (tboot) module. This will utilize
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
