Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2JHAoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:44:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52118 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2JHAoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:44:02 -0400
Date: Sun, 7 Oct 2012 17:43:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, akpm@linux-foundation.org, andi@firstfloor.org
Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
Message-ID: <20121008004358.GA12342@kroah.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349654386-18378-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 04:59:45PM -0700, K. Y. Srinivasan wrote:
> The policy engine on the host expects the guest to report the
> committed_as. Since this variable is not exported,
> export this symbol.

Why are these symbols not needed by either Xen or KVM or vmware, which
I think all support the same thing, right?

> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -87,6 +87,7 @@ int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
>   * other variables. It can be updated by several CPUs frequently.
>   */
>  struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
> +EXPORT_SYMBOL(vm_committed_as);
>  
>  /*
>   * Check that a process has enough memory to allocate a new virtual
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 45131b4..3914b7e 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -68,6 +68,7 @@ atomic_long_t mmap_pages_allocated;
>  
>  EXPORT_SYMBOL(mem_map);
>  EXPORT_SYMBOL(num_physpages);
> +EXPORT_SYMBOL(vm_committed_as);

EXPORT_SYMBOL_GPL() for these new ones?

greg k-h
