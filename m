Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2IFHWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:22:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53646 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2IFHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:22:22 -0400
Date: Thu, 6 Sep 2012 10:22:19 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 14/14] x86, mm: Map ISA area with connected ram range
 at the same time
In-Reply-To: <CAE9FiQWTRndGpRDDfiB4RqRPC6sEt252P+QnjPd0+sH8k3YBwg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1209061021440.2210@tux.localdomain>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org> <1346823991-22911-15-git-send-email-yinghai@kernel.org> <CAOJsxLGXQ9+5uEvq-Pfxt=zZLWR3ZmR1WPeN=pzdzQVjHWrd0g@mail.gmail.com>
 <CAE9FiQWTRndGpRDDfiB4RqRPC6sEt252P+QnjPd0+sH8k3YBwg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 1:02 AM, Pekka Enberg <penberg@kernel.org> wrote:
> > How significant is the speed gain? The "isa_done" flag makes code flow
> > more difficult to follow.

On Wed, 5 Sep 2012, Yinghai Lu wrote:
> Not really much.
> 
> when booting system:
> memmap=16m$128m memmap=16m$512m memmap=16m$256m memmap=16m$768m memmap=16m$1024m
> 
> with the patch
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x07ffffff]
> [    0.000000]  [mem 0x00000000-0x07ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x09000000-0x0fffffff]
> [    0.000000]  [mem 0x09000000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x11000000-0x1fffffff]
> [    0.000000]  [mem 0x11000000-0x1fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x21000000-0x2fffffff]
> [    0.000000]  [mem 0x21000000-0x2fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x31000000-0x3fffffff]
> [    0.000000]  [mem 0x31000000-0x3fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x41000000-0x7fffdfff]
> [    0.000000]  [mem 0x41000000-0x7fdfffff] page 2M
> [    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
> 
> otherwise will have
> 
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x07ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x09000000-0x0fffffff]
> [    0.000000]  [mem 0x09000000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x11000000-0x1fffffff]
> [    0.000000]  [mem 0x11000000-0x1fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x21000000-0x2fffffff]
> [    0.000000]  [mem 0x21000000-0x2fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x31000000-0x3fffffff]
> [    0.000000]  [mem 0x31000000-0x3fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x41000000-0x7fffdfff]
> [    0.000000]  [mem 0x41000000-0x7fdfffff] page 2M
> [    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k

OK. Is there any other reason than performance to do this?

			Pekka
