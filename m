Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab1CNXFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:05:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40697 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1CNXF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:05:28 -0400
Message-ID: <4D7E9F0C.2010504@zytor.com>
Date: Mon, 14 Mar 2011 16:04:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: lkml <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86 : Add NX protection for kernel data on 64 bit
References: <4D7D0ED6.2050504@free.fr>
In-Reply-To: <4D7D0ED6.2050504@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 11:37 AM, matthieu castet wrote:
> Cpu hotplug code read data in head_64.S (phys_base) before enabling NX, so when
> we enable NX on data, an triple fault happen because a reserved bit is set.
> It was fixed by allocating dedicated page table for ident mapping in trampoline.
> Now data can be protected by NX.
> 
> The Low kernel Mapping is also set to NX.
> 
> Finaly we preserve large page mapping by applying nx in free_init_pages only 
> when we switch to NX mode

The right way to do this is to have initial_page_table and keep it
around, just as we already do on 32 bits... yet another thing that can
be merged instead of coming up with a separate solution.

	-hpa
