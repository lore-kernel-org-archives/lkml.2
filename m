Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0CWJsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 05:48:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56973 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0CWJsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 05:48:52 -0400
Date: Tue, 23 Mar 2010 10:48:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
Message-ID: <20100323094834.GB4576@elte.hu>
References: <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
 <4BA7EE72.7000507@kernel.org>
 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>
 <4BA80019.5000900@kernel.org>
 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
 <4BA813A4.1010704@kernel.org>
 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
 <4BA8594F.8090205@kernel.org>
 <20100323080252.GA4848@elte.hu>
 <4BA883C0.2070102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA883C0.2070102@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> > 2)
> > 
> > I think we also need to concentrate the changes back into LMB:
> 
> yes. put them in kernel/early_res.c and move them to lmb.c if lmb gugs are 
> happy with the change.

Yes, they seemed OK with changing it to accomodate x86, as long as current 
behavior stays compatible and as long as the changes are squeaky-clean.

Both of which are highly reasonable expectations ;-)

> > early_res.h will go away as well and all the new APIs will be in lmb.h.
> 
> current have three levels
> a. old lmb users
> b. x86 with bootmem
> c. x86 with no-bootmem
> 
> some functions later could be moved to new bootmem.c

I think we want to work towards the end result where we dont have bootmem.c 
anymore. I.e. a modern LMB architecture should generally not make use of 
bootmem at all.

We could do that switch on x86 straight away, and make CONFIG_NO_BOOTMEM a 
default-y option, hm? We could also hide the interactivity behind 
CONFIG_DEBUG_VM or so - and eliminate it altogether later on.

We should also switch around the flag and turn it into CONFIG_BOOTMEM.

Hm?

	Ingo
