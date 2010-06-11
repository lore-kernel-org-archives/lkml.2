Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0FKRld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:41:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58807 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab0FKRlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:41:31 -0400
Message-ID: <4C127531.90902@zytor.com>
Date: Fri, 11 Jun 2010 10:41:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [RFC][PATCH 0/4] x86: ioremap() problem in X86_32 PAE
References: <4C11FF10.4060203@jp.fujitsu.com>
In-Reply-To: <4C11FF10.4060203@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 02:17 AM, Kenji Kaneshige wrote:
> 
> By the way, I'm wondering some change might be needed also in PCI side.
> For example, current PCI subsystem disables 64-bit BAR with address
> higher than 32-bit assigned if sizeof(resource_size_t) is less than 8.
> But it doesn't care the case sizeof(resource_size_t) is equal to 8 on
> the system that cannot handle whole 64-bit physical address, like
> X86_32 PAE. In relation to this, my system is doing the following
> interesting behavior.
> 
> - On x86_32 without PAE, ioatdma works because 64-bit BAR is once
>   cleared and then lower address is assigned again.
> 
> - On x86_32 with PAE, ioatdma doesn' work even with my patch set.
>   Without my patch, kernel hangup or panic happens. With my patch,
>   ioatdma driver fails to initialize the device because ioremap()
>   returns NULL.
> 
> Anyway, I think ioremap() problem needs to be fixed first.
> 

We had a patch in for a while to cap the physical address space to the
number of bits supported by the CPU.  It got removed because it caused a
regression, which turned out to be because it exposed another bug (which
has since been fixed) -- I have been meaning to put it back in.

	-hpa
