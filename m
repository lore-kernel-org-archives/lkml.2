Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2BVUUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:20:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2BVUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:20:04 -0500
Date: Wed, 22 Feb 2012 12:20:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Mike Habeck <habeck@sgi.com>
Subject: Re: [PATCH 1/3] x86 PCI: Fix identity mapping for sandy bridge
Message-Id: <20120222122002.f4932e08.akpm@linux-foundation.org>
In-Reply-To: <20120202235650.736578988@gulag1.americas.sgi.com>
References: <20120202235650.563029146@gulag1.americas.sgi.com>
	<20120202235650.736578988@gulag1.americas.sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Feb 2012 17:56:51 -0600
Mike Travis <travis@sgi.com> wrote:

> --- linux.orig/drivers/iommu/intel-iommu.c
> +++ linux/drivers/iommu/intel-iommu.c
> @@ -48,8 +48,6 @@
>  #define ROOT_SIZE		VTD_PAGE_SIZE
>  #define CONTEXT_SIZE		VTD_PAGE_SIZE
>  
> -#define IS_BRIDGE_HOST_DEVICE(pdev) \
> -			    ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
>  #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
>  #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
>  #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)

I suppose it would be tiresome to point out what happens when someone
does IS_GFX_DEVICE(pdev + 1).

Macros: Just Don't Do It.
