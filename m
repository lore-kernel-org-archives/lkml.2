Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0CVVEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:04:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:53987 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0CVVEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:04:33 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20100322130530.GC12475@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
	 <20100321.210023.209981130.davem@davemloft.net>
	 <4BA6F1F6.3070102@kernel.org>
	 <20100321.213350.176660494.davem@davemloft.net>
	 <20100322092809.GA20607@elte.hu>
	 <20100322113026.GA11526@brick.ozlabs.ibm.com>
	 <20100322130530.GC12475@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 08:04:05 +1100
Message-ID: <1269291846.8599.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 14:05 +0100, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > And I don't see the point of moving the x86 e820 stuff into the kernel 
> > directory. [...]
> 
> I dont see the point of that either - that is a mistake. e820 is an x86 bios 
> call and we shouldnt name a generic mechanism after that. e820 is absolutely 
> messy and has no place anywhere beyond x86.
> 
> The main technical argument i see is 'early_res versus LMB'. Even there i'd 
> prefer LMB from a technical quality POV.

Then we have no argument. The point is, we object to that fw_memmap/e820
stuff taking over for non-x86 architectures. We aren't saying that x86
-must- move to LMB, but if the wish is to have a common implementation
in generic code accross all archs, -then- we object to it being e820.

Ben.


