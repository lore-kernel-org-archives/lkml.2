Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030536Ab2CGWIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:08:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41749 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030251Ab2CGWIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:08:16 -0500
Date: Wed, 7 Mar 2012 14:08:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 08/13] android: persistent_ram: handle reserving and
 mapping memory
Message-ID: <20120307220811.GB16652@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
 <1331157503-3413-9-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331157503-3413-9-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:58:18PM -0800, John Stultz wrote:
> From: Colin Cross <ccross@android.com>
> 
> Replace the ioremapped memory passed in from the drivers with
> a memblock_reserve and vmap.  Adds a new function,
> persistent_ram_early_init, designed to be called from the machine
> init_early callback, that calls memblock_remove and saves the
> provided persistent ram area layout.
> 
> Drivers only pass in their struct device * and ecc settings.
> Locating and mapping the memory is now handled entirely within
> persistent_ram.
> 
> Also, convert ram_console to the new persistent_ram_init
> parameters that only take a struct device * and ecc settings.
> 
> CC: Greg KH <gregkh@linuxfoundation.org>
> CC: Android Kernel Team <kernel-team@android.com>
> Change-Id: Ibc87ec27b70ed1c928eaa487503469e199973058
> Change-Id: I12b018381a2ed5965a8a4b0da40c3e640f92b6cf
> Signed-off-by: Colin Cross <ccross@android.com>
> [jstultz: Fix pr_info casting issues on 64bit, folded two
> patches as the build breaks if they are apart. Also replaced
> phys_to_page() w/ pfn_to_page(addr>>PAGE_SHIFT), as phys_to_page
> is only on a few arches.]

Please put your comments above the signed-off-by area, it makes it
easier on tools that parse this area.

thanks,

greg k-h
