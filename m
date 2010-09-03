Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0ICJx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:53:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab0ICJx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:53:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTikBLCg_FUwGGiajw3+dgCe6y0s0a1yMs8=A2oCR@mail.gmail.com>
References: <AANLkTikBLCg_FUwGGiajw3+dgCe6y0s0a1yMs8=A2oCR@mail.gmail.com> <m3vd6nmd68.fsf@hase.home> <19747.1283422807@redhat.com> <20100902102158.19806.14133.stgit@warthog.procyon.org.uk> <m38w3kns4r.fsf@hase.home> <AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com> <3048.1283505520@redhat.com> <4C80C068.1010302@snapgear.com> 
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, Greg Ungerer <gerg@snapgear.com>,
        Andreas Schwab <schwab@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu contributions
Date: Fri, 03 Sep 2010 10:52:57 +0100
Message-ID: <7877.1283507577@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > Not sure about m68k but m68knommu targets already setup
> > appropriate -mcpu flags for its various supported CPU types.
> 
> Same for m68k.

It doesn't seem to:

	warthog>grep -r mcpu arch/m68k
	warthog1>grep -r mtune arch/m68k
	warthog1>

I see that m68knommu does:

	warthog1>grep -r mcpu arch/m68knommu/
	arch/m68knommu/Makefile:cflags-$(CONFIG_M5206)          := $(call cc-option,-mcpu=5206,-m5200)
	arch/m68knommu/Makefile:cflags-$(CONFIG_M520x)          := $(call cc-option,-mcpu=5208,-m5200)
	arch/m68knommu/Makefile:cflags-$(CONFIG_M523x)          := $(call cc-option,-mcpu=523x,-m5307)
	...

I guess the m68k compiler I already had doesn't fully support -m5200, since I
see that, but it doesn't compile some of the instructions when compiling the
m68knommu defconfig (CONFIG_M520x=y).

David
