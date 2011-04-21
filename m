Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1DUCcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:32:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1DUCcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=QXZD6f2bdkPSq1q2ItSwlHzj3Z6RlyFYYempIMC5cAn1owF+uPoI6OcP84p8w9194G
         uQEPCEYRFoshoeCv7lqA==
Date: Wed, 20 Apr 2011 19:31:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] x86: allow ZONE_DMA to be configurable
In-Reply-To: <4DA8A5CE.2010004@zytor.com>
Message-ID: <alpine.DEB.2.00.1104201929170.15661@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com> <4DA82F33.7080403@ladisch.de> <4DA8A5CE.2010004@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, H. Peter Anvin wrote:

> On 04/15/2011 04:42 AM, Clemens Ladisch wrote:
> > David Rientjes wrote:
> >> ZONE_DMA is unnecessary for a large number of machines that do not
> >> require addressing in the lower 16MB of memory because they do not use
> >> ISA devices with 16-bit address registers (plus one page byte register).
> >>
> >> This patch allows users to disable ZONE_DMA for x86 if they know they
> >> will not be using such devices with their kernel.
> >> ...
> >>  config ZONE_DMA
> >> -	def_bool y
> >> +	bool "DMA memory allocation support" if EXPERT
> > 
> > Better call it "ISA/LPC DMA memory allocation support".
> > 
> >> +	default y
> > 
> > Does it make sense to have this without CONFIG_ISA_DMA_API?
> > 
> >> +	help
> >> +	  DMA memory allocation support allows old ISA devices with 16-bit
> >> +	  address registers to allocate memory within the first 16MB of
> >> +	  address space.  Disable if no such devices will be used.
> > 
> > "Old ISA devices" might be misleading because ISA does not imply actual
> > ISA slots; please mention LPC devices like the floppy controller and the
> > parallel port in ECP mode.
> > 
> 
> This isn't really a very good edit, as ZONE_DMA isn't inherently limited
> to ISA/LPC devices (and LPC devices which do LPC-native bus mastering
> DMA are not affected.)  ZONE_DMA is used even for some PCI devices which
> have restrictions on the DMA address mask.
> 

Peter, do you think we can merge this patch now?  The discussion from 
October resulted in the decision to rename CONFIG_EMBEDDED to 
CONFIG_EXPERT and make CONFIG_GENERIC_ISA_DMA and CONFIG_ISA_DMA_API 
configurable for x86.  That's all been done via the -mm tree and is in the 
latest git.

We've run without ZONE_DMA for a few years without issues (and, obviously, 
this patch) on x86.
