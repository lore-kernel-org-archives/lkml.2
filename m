Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab1BCUCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:02:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:53671 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab1BCUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:02:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GKQDVjugfKCGID84Y8j1zIhAKqpQviXGlaxA5uWUVlTZBquOubZkTlqSXfxPrIBnW6
         fhlCqgC7Vg6ggk8p+F2w==
Date: Thu, 3 Feb 2011 12:01:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] pnp: only assign IORESOURCE_DMA if CONFIG_ISA_DMA_API
 is enabled
In-Reply-To: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1102031201430.27201@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, David Rientjes wrote:

> IORESOURCE_DMA cannot be assigned without utilizing the interface
> provided by CONFIG_ISA_DMA_API, specifically request_dma() and
> free_dma().  Thus, there's a strict dependency on the config option and
> limits IORESOURCE_DMA only to architectures that support ISA-style DMA.
> 
> ia64 is not one of those architectures, so pnp_check_dma() no longer
> needs to be special-cased for that architecture.
> 
> pnp_assign_resources() will now return -EINVAL if IORESOURCE_DMA is
> attempted on such a kernel.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Are there any objections to merging this?
