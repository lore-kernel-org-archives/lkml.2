Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0JNAYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:24:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50794 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JNAYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:24:18 -0400
Message-ID: <4CB64D8F.9080800@zytor.com>
Date: Wed, 13 Oct 2010 17:23:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 05:15 PM, David Rientjes wrote:
> ZONE_DMA is unnecessary for a large number of machines that do not
> require addressing in the lower 16MB of memory because they do not use
> ISA devices with 16-bit address registers (plus one page byte register).
> 
> This patch allows users to disable ZONE_DMA for x86 if they know they
> will not be using such devices with their kernel.
> 
> This prevents the VM from unnecessarily reserving a ratio of memory
> (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> for such allocations when it will never be used.

This isn't true.

There are many, many devices other than ISA devices which need access to
a restricted-memory pool because of hardware DMA limitations.  This
seems like a really bad idea.

A much better idea would be to have a runtime option of setting the
reservation ratio, if recovering no more than 1/66th of a gigabyte
matters so much to you.

	-hpa
