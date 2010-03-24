Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab0CXEbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:31:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:33294 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab0CXEbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:31:02 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.cy
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100323094834.GB4576@elte.hu>
References: <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
	 <4BA7EE72.7000507@kernel.org>
	 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>
	 <4BA80019.5000900@kernel.org>
	 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
	 <4BA813A4.1010704@kernel.org>
	 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
	 <4BA8594F.8090205@kernel.org> <20100323080252.GA4848@elte.hu>
	 <4BA883C0.2070102@kernel.org>  <20100323094834.GB4576@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 15:29:42 +1100
Message-ID: <1269404982.8599.148.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 10:48 +0100, Ingo Molnar wrote:
> > yes. put them in kernel/early_res.c and move them to lmb.c if lmb
> gugs are 
> > happy with the change.
> 
> Yes, they seemed OK with changing it to accomodate x86, as long as
> current 
> behavior stays compatible and as long as the changes are
> squeaky-clean.
> 
> Both of which are highly reasonable expectations ;-)

Yup. As I said, tho, I'd also like a little better level of explanation
and documentation (and I know the existing LMB interfaces are -not-
documented, but let's not add more shall we ? :-)

> I think we want to work towards the end result where we dont have
> bootmem.c  anymore. I.e. a modern LMB architecture should generally
> not make use of bootmem at all.

bootmem has one advantage over LMB, I think, in that LMB has this
annoying static array of regions, which is prone to being either too big
(wasted space) or too small.

We might want to consider a slightly smarter approach there if we are
going to replace bootmem.

I though one possibility would be to have LMB regions become more lists
than arrays, so that the static storage only needs to cover as much as
is needed during really early boot (and we could probably still move the
BSS top point on some archs to dynamically make more ... actually we
could be smart arses and use LMB to allocate more LMB list heads if we
are reaching the table limit :-)

> We could do that switch on x86 straight away, and make
> CONFIG_NO_BOOTMEM a 
> default-y option, hm? We could also hide the interactivity behind 
> CONFIG_DEBUG_VM or so - and eliminate it altogether later on.
> 
> We should also switch around the flag and turn it into CONFIG_BOOTMEM.

Cheers,
Ben.

> Hm?
> 
>         Ingo
> 
> 

