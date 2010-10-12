Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab0JLSll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:41:41 -0400
Received: from claw.goop.org ([74.207.240.146]:49855 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0JLSlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:41:40 -0400
Message-ID: <4CB4ABE2.3010300@goop.org>
Date: Tue, 12 Oct 2010 11:41:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org>
In-Reply-To: <4CAA4DC1.6000104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/04/2010 02:57 PM, Yinghai Lu wrote:
> Please check memblock related patches
>
> [PATCH 1/4] memblock: Fix big size with find_region()
> [PATCH -v5 2/4] x86, memblock: Fix crashkernel allocation
> [PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
> [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges
>
> first one should get into core/memblock branch, and others should be in x86/mm/memeblock branch


BTW, the memblock changes prevent the kernel from booting under Xen; it
crashes while setting up the linear maps.  I haven't worked out what's
failing yet, aside from bisecting it down to one of a9ce6bc151000 or
72d7c3b33c9808 (they don't compile in isolation so I had to skip them,
but both are likely looking, but unfortunately large, complex and hard
to further subdivide).

I'll look further into this, but just a heads-up for the upcoming merge
window.

    J
