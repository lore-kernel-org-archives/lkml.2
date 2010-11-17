Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071Ab0KQRYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:24:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36436 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934729Ab0KQRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:24:53 -0500
Date: Wed, 17 Nov 2010 17:24:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/20] ARM: LPAE: Introduce L_PTE_NOEXEC and
	L_PTE_NOWRITE
Message-ID: <20101117172425.GE5308@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-6-git-send-email-catalin.marinas@arm.com> <20101115183014.GD31421@n2100.arm.linux.org.uk> <AANLkTik5FcZ3rNtiwN8kYP0LZh+YqGtKP_RteoFiWa16@mail.gmail.com> <20101117171613.GB5308@n2100.arm.linux.org.uk> <AANLkTincmfqXmNQznd1fdSRYd4Vc+p47cgTfEwQoXdFm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTincmfqXmNQznd1fdSRYd4Vc+p47cgTfEwQoXdFm@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 05:22:12PM +0000, Catalin Marinas wrote:
> Ah, good point, that was the mask.
> 
> So for dmacoherent we make sure that L_PTE_EXEC is cleared. I suspect
> we should now make sure that L_PTE_NOEXEC is set. For the other two,
> just leave them as they are.

Already done:

 #define pgprot_dmacoherent(prot) \
-       __pgprot_modify(prot, L_PTE_MT_MASK|L_PTE_EXEC, L_PTE_MT_BUFFERABLE)
+       __pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_BUFFERABLE|L_PTE_XN)
...
 #define pgprot_dmacoherent(prot) \
-       __pgprot_modify(prot, L_PTE_MT_MASK|L_PTE_EXEC, L_PTE_MT_UNCACHED)
+       __pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_UNCACHED|L_PTE_XN)
