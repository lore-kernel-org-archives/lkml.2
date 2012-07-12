Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab2GLLXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:23:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:40525 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab2GLLXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:23:33 -0400
Message-ID: <1342092201.15597.0.camel@pasglop>
Subject: Re: [PATCH] powerpc: remove rejected merge file from
 arch/powerpc/kernel in linux-next
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stuart.yoder@freescale.com
Date: Thu, 12 Jul 2012 21:23:21 +1000
In-Reply-To: <1342076734-30996-1-git-send-email-dev@snitselaar.org>
References: <1342076734-30996-1-git-send-email-dev@snitselaar.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 00:05 -0700, Gerard Snitselaar wrote:
> Commit 9778b696 (powerpc: Use CURRENT_THREAD_INFO instead of open
> coded assembly) got a rejected merge file iommu.c.rej committed with
> it.

Oops, that's me having too much coffee & using git citool ... I'll get
rid of it, thanks.

Cheers,
Ben.

> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
> ---
>  arch/powerpc/kernel/iommu.c.rej | 22 ----------------------
>  1 file changed, 22 deletions(-)
>  delete mode 100644 arch/powerpc/kernel/iommu.c.rej
> 
> diff --git a/arch/powerpc/kernel/iommu.c.rej b/arch/powerpc/kernel/iommu.c.rej
> deleted file mode 100644
> index 9d10d34..0000000
> --- a/arch/powerpc/kernel/iommu.c.rej
> +++ /dev/null
> @@ -1,22 +0,0 @@
> ---- arch/powerpc/kernel/iommu.c	2012-06-08 09:01:02.785709100 +1000
> -+++ arch/powerpc/kernel/iommu.c	2012-06-08 09:01:07.489784856 +1000
> -@@ -33,7 +33,9 @@
> - #include <linux/bitmap.h>
> - #include <linux/iommu-helper.h>
> - #include <linux/crash_dump.h>
> -+#include <linux/fault-inject.h>
> - #include <asm/io.h>
> -+#include <asm/vio.h>
> - #include <asm/prom.h>
> - #include <asm/iommu.h>
> - #include <asm/pci-bridge.h>
> -@@ -171,6 +261,9 @@
> - 		return DMA_ERROR_CODE;
> - 	}
> - 
> -+	if (should_fail_iommu(dev))
> -+		return DMA_ERROR_CODE;
> -+
> - 	if (handle && *handle)
> - 		start = *handle;
> - 	else


