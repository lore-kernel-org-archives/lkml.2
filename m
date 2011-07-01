Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1GAQFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:05:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58969 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab1GAQFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:05:47 -0400
Message-ID: <4E0DEF2C.3040504@zytor.com>
Date: Fri, 01 Jul 2011 09:00:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Petr Tesarik <ptesarik@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <201106171038.25988.ptesarik@suse.cz> <20110701144129.GA10052@infradead.org> <20110701144641.GA23272@elte.hu> <201107011654.06651.ptesarik@suse.cz> <20110701153634.GA27407@elte.hu>
In-Reply-To: <20110701153634.GA27407@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 08:36 AM, Ingo Molnar wrote:
> 
> So we could kill multiple birds with the same stone here:
> 
>  - remove various ugly uses of /dev/mem (including the rootkit usage),
>    with or without strict-devmem
> 
>  - extending it to above-4G for inspection purposes
> 
>  - allowing to kill /dev/mem access runtime similar to the 
>    disable_modules lock-down killswitch, for the so inclined.
> 
> Would you be interested in modifying your patch-set in such a 
> fashion?
> 

There is another use that I have looked at, as well: for testing
purposes, it would be extremely good to be able to dirty and/or flush an
arbitrary physical cache line for testing purposes.

This is very very similar to /dev/mem usage -- access to an arbitrary
chunk of memory -- and a fully enabled /dev/mem can of course support
this use (just mmap the page with the relevant cache line).  However, it
could also be a separate device which could have looser permissions than
/dev/mem; or a set of ioctls on /dev/mem with a separate kill switch,
because no data would ever be have modified or returned to user space.

Either way, though, we found that it would share a lot of code with the
/dev/mem implementation, and as such fixing up the underlying machinery
is the sanest way to upstream this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

