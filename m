Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab0CXE0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:26:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:50017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0CXE0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:26:51 -0400
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
In-Reply-To: <20100323080252.GA4848@elte.hu>
References: <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org>
	 <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
	 <4BA7EE72.7000507@kernel.org>
	 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>
	 <4BA80019.5000900@kernel.org>
	 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
	 <4BA813A4.1010704@kernel.org>
	 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
	 <4BA8594F.8090205@kernel.org>  <20100323080252.GA4848@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 15:24:46 +1100
Message-ID: <1269404686.8599.144.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 09:02 +0100, Ingo Molnar wrote:
> > -u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
> > +u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
> > +u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
> > +u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64
> align);
> > +void lmb_register_active_regions(int nid, unsigned long start_pfn,
> > +                                      unsigned long last_pfn);
> > +u64 lmb_hole_size(u64 start, u64 end);
> >  u64 get_max_mapped(void);
> >  #include <linux/range.h>
> >  int get_free_all_memory_range(struct range **rangep, int nodeid);
> 
> those new lmb_*() APIs should go into lmb.h.

And while at it properly documented :-) I wouldn't mind also a
reasonably clear explanation in the changeset comment as to why
they are necessary for x86.

To be honest, that's my #1 grief so far with this entire patch set,
it Yinghai apparent inability to write anything ressembling remotely
like an explanation. All we get is key words, bullet points and half
sentences, and I admit have a very very hard time extracting a meaning
out of anything he's been writing so far.

Cheers,
Ben.


