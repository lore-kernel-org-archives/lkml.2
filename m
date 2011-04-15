Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1DOLlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:41:00 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:54508 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1DOLk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:40:59 -0400
Message-ID: <4DA82F33.7080403@ladisch.de>
Date: Fri, 15 Apr 2011 13:42:43 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> ZONE_DMA is unnecessary for a large number of machines that do not
> require addressing in the lower 16MB of memory because they do not use
> ISA devices with 16-bit address registers (plus one page byte register).
> 
> This patch allows users to disable ZONE_DMA for x86 if they know they
> will not be using such devices with their kernel.
> ...
>  config ZONE_DMA
> -	def_bool y
> +	bool "DMA memory allocation support" if EXPERT

Better call it "ISA/LPC DMA memory allocation support".

> +	default y

Does it make sense to have this without CONFIG_ISA_DMA_API?

> +	help
> +	  DMA memory allocation support allows old ISA devices with 16-bit
> +	  address registers to allocate memory within the first 16MB of
> +	  address space.  Disable if no such devices will be used.

"Old ISA devices" might be misleading because ISA does not imply actual
ISA slots; please mention LPC devices like the floppy controller and the
parallel port in ECP mode.


Regards,
Clemens
