Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2LUNu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:50:27 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:46136 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153Ab2LUNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:50:22 -0500
Message-ID: <1356097818.1490.109.camel@tellur>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
From: Lucas Stach <dev@lynxeye.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: thierry.reding@avionic-design.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2012 14:50:18 +0100
In-Reply-To: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 21.12.2012, 13:39 +0200 schrieb Terje Bergstrom:
> This set of patches adds support for Tegra20 and Tegra30 host1x and
> 2D. It is based on linux-next-20121220.
> 
> The fourth version has only few changes compared to previous version:
>  * Fixed some sparse warnings
>  * Fixed host1x Makefile to allow building as module
>  * Fixed host1x module unload
>  * Fixed tegradrm unload sequence
>  * host1x creates DRM dummy device and tegradrm uses it for storing
>    DRM related data.
> 
> Some of the issues left open:
>  * Register definitions still use static inline. There has been a
>    debate about code style versus ability to use compiler type
>    checking and code coverage analysis. There was no conclusion, so
>    I left it as was.
This has to be resolved before merging. Personally I'm in favour of
keeping reg access patterns close to what is done in other parts of the
kernel.

>  * Uses still CMA helpers. IOMMU support will replace CMA with host1x
>    specific allocator.

I really want the allocator issue resolved before talking about merging
those patches. Proper IOMMU support will require a bit of rework of the
current upstream IOMMU API, so it will still be a bit out.

But if you don't mind I'll try to implement the host1x allocator over
the holidays and provide an incremental patch.

Regards,
Lucas

