Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0LUOTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 09:19:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0LUOTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 09:19:39 -0500
Message-ID: <4D10B775.6040500@suse.cz>
Date: Tue, 21 Dec 2010 15:19:33 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sodaville@linutronix.de, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/4] x86/of: Add building device tree blob(s) into image.
References: <cover.1291820033.git.dirk.brandewie@gmail.com> <abe67e5689fef1d94e57be68ec5ef47a8f13bf8e.1291820034.git.dirk.brandewie@gmail.com>
In-Reply-To: <abe67e5689fef1d94e57be68ec5ef47a8f13bf8e.1291820034.git.dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.12.2010 16:01, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch adds linking device tree blob into vmlinux. DTB's are
> added by adding the blob object name to list of objects to be linked
> into the image.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  arch/x86/platform/ce4100/Makefile |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/platform/ce4100/Makefile b/arch/x86/platform/ce4100/Makefile
> index 91fc929..e5f3b7b 100644
> --- a/arch/x86/platform/ce4100/Makefile
> +++ b/arch/x86/platform/ce4100/Makefile
> @@ -1 +1,11 @@
>  obj-$(CONFIG_X86_INTEL_CE)	+= ce4100.o
> +clean-files := *dtb.S
> +
> +ifdef CONFIG_X86_OF
> +###
> +# device tree blob
> +obj-$(CONFIG_X86_INTEL_CE) += ce4100.dtb.o
> +
> +$(obj)/%.dtb: $(src)/%.dts
> +	$(call cmd,dtc)
> +endif

Hi,

CONFIG_X86_OF should be defined in some Kconfig file and there is no
ce4100.dts??

Michal
