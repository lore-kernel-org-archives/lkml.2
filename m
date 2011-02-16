Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1BPQZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:25:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1BPQZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:25:03 -0500
Message-ID: <4D5BFAB7.5070504@redhat.com>
Date: Wed, 16 Feb 2011 11:26:31 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
References: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6> <20110215195450.GO5935@random.random> <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6> <alpine.LFD.2.00.1102152125180.26192@localhost6.localdomain6> <20110215225234.GP5935@random.random> <alpine.LFD.2.00.1102160002300.26192@localhost6.localdomain6> <20110215231733.GR5935@random.random> <1297850294.2413.30.camel@twins> <20110216101521.GU5935@random.random> <20110216102801.GA23082@elte.hu> <20110216144947.GA5935@random.random>
In-Reply-To: <20110216144947.GA5935@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 09:49 AM, Andrea Arcangeli wrote:

> Subject: fix pgd_lock deadlock
>
> From: Andrea Arcangeli<aarcange@redhat.com>
>
> It's forbidden to take the page_table_lock with the irq disabled or if there's
> contention the IPIs (for tlb flushes) sent with the page_table_lock held will
> never run leading to a deadlock.
>
> Apparently nobody takes the pgd_lock from irq so the _irqsave can be removed.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>


Acked-by: Rik van Riel <riel@redhat.com>
