Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0CZV67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:58:59 -0400
Received: from sous-sol.org ([216.99.217.87]:57336 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752385Ab0CZV66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:58:58 -0400
Date: Fri, 26 Mar 2010 14:58:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: jbarnes@virtuousgeek.org, David.Woodhouse@intel.com, len.brown@intel.com,
       chrisw@sous-sol.org, suresh.b.siddha@intel.com, mingo@elte.hu,
       yu.zhao@intel.com, fenghua.yu@intel.com, weidong@intel.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] dmar: section mismatch cleanup
Message-ID: <20100326215804.GF29241@sequoia.sous-sol.org>
References: <1269633200-19970-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269633200-19970-1-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Henrik Kretzschmar (henne@nachtwindheim.de) wrote:
> This patch fixes a section mismatch.
> 
> WARNING: drivers/pci/built-in.o(.text+0x182f5): Section mismatch in
> reference from the function dmar_ir_support() to the variable
> .init.data:acpi_slot_detected
> The function dmar_ir_support() references
> the variable __initdata acpi_slot_detected.
> This is often because dmar_ir_support lacks a __initdata
> annotation or the annotation of acpi_slot_detected is wrong.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Acked-by: Chris Wright <chrisw@sous-sol.org>

> -int dmar_ir_support(void)
> +int __init dmar_ir_support(void)

> -extern int dmar_ir_support(void);
> +extern int dmar_ir_support(void) __init;

Nit, but prerfer to see:

-extern int dmar_ir_support(void);
+extern int __init dmar_ir_support(void);

thanks,
-chris
