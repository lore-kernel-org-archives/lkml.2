Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2IFONY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:13:24 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23570 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755900Ab2IFONW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:13:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Izz1202hzz8275dhz2dh668h839h944hd25hd2bhf0ah107ah1220h1155h)
X-WSS-ID: 0M9XM64-02-6PQ-02
X-M-MSG: 
Date: Thu, 6 Sep 2012 09:13:14 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Pekka Enberg <penberg@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 14/14] x86, mm: Map ISA area with connected ram range
 at the same time
Message-ID: <20120906141305.GA10013@jshin-Toonie>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
 <1346823991-22911-15-git-send-email-yinghai@kernel.org>
 <CAOJsxLGXQ9+5uEvq-Pfxt=zZLWR3ZmR1WPeN=pzdzQVjHWrd0g@mail.gmail.com>
 <CAE9FiQWTRndGpRDDfiB4RqRPC6sEt252P+QnjPd0+sH8k3YBwg@mail.gmail.com>
 <alpine.LFD.2.02.1209061021440.2210@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1209061021440.2210@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:22:19AM +0300, Pekka Enberg wrote:
> On Wed, Sep 5, 2012 at 1:02 AM, Pekka Enberg <penberg@kernel.org> wrote:
> > > How significant is the speed gain? The "isa_done" flag makes code flow
> > > more difficult to follow.
> 
> On Wed, 5 Sep 2012, Yinghai Lu wrote:
> > Not really much.
> > 
> > when booting system:
> > memmap=16m$128m memmap=16m$512m memmap=16m$256m memmap=16m$768m memmap=16m$1024m
> > 
> > with the patch
> > [    0.000000] init_memory_mapping: [mem 0x00000000-0x07ffffff]
> > [    0.000000]  [mem 0x00000000-0x07ffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x09000000-0x0fffffff]
> > [    0.000000]  [mem 0x09000000-0x0fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x11000000-0x1fffffff]
> > [    0.000000]  [mem 0x11000000-0x1fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x21000000-0x2fffffff]
> > [    0.000000]  [mem 0x21000000-0x2fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x31000000-0x3fffffff]
> > [    0.000000]  [mem 0x31000000-0x3fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x41000000-0x7fffdfff]
> > [    0.000000]  [mem 0x41000000-0x7fdfffff] page 2M
> > [    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
> > 
> > otherwise will have
> > 
> > [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> > [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> > [    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
> > [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> > [    0.000000]  [mem 0x00200000-0x07ffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x09000000-0x0fffffff]
> > [    0.000000]  [mem 0x09000000-0x0fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x11000000-0x1fffffff]
> > [    0.000000]  [mem 0x11000000-0x1fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x21000000-0x2fffffff]
> > [    0.000000]  [mem 0x21000000-0x2fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x31000000-0x3fffffff]
> > [    0.000000]  [mem 0x31000000-0x3fffffff] page 2M
> > [    0.000000] init_memory_mapping: [mem 0x41000000-0x7fffdfff]
> > [    0.000000]  [mem 0x41000000-0x7fdfffff] page 2M
> > [    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
> 
> OK. Is there any other reason than performance to do this?

May be minor, but ..

The first range [mem 0x00000000-0x07ffffff] is covered entirely by 2M
page tables, instead of some 4K + some 2M.

-Jacob

> 
> 			Pekka
> 

