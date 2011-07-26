Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab1GZF7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:59:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48280 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1GZF7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:59:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110725215328.GA25960@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab> <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
 <20110724182323.GA13247@aftab> <20110724183045.GB29660@elte.hu>
 <20110724190752.GA13647@aftab> <20110724204450.GB18546@elte.hu>
 <20110725200014.GA23986@aftab> <20110725200645.GC8302@elte.hu> <20110725215328.GA25960@aftab>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 25 Jul 2011 22:58:43 -0700
X-Google-Sender-Auth: 5mouqIxJXsddf2cEw6DNHVmtJsU
Message-ID: <CADU53JV-aKbRU-iixbqcv_kAci7L6z43GYmP6uw8hZdY4PrBbQ@mail.gmail.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 2:53 PM, Borislav Petkov <bp@amd64.org> wrote:
>
> On Mon, Jul 25, 2011 at 04:06:45PM -0400, Ingo Molnar wrote:
> >
> > * Borislav Petkov <bp@amd64.org> wrote:
> >
> > > So yeah, the simpler fix works for processes mapping libraries in
> > > the same order but not for processes mapping a subset of libraries
> > > in a different order.
> >
> > but what is the proportion of 'good' versus bad alignment of
> > libraries, could you collect some stats on a representative enough,
> > fully booted up Linux system?
> >
> > Are only 1% of mappings 'bad'? 5%? 10%? 50%? We have no idea and the
> > actual number matters a lot.
>
> Actually, it's hard to say what is a 'good' and 'bad' allocation. If
> they don't alias, they're always good :).

Count the number of aliases per total mappings, and report that as a
failure percentage? It doesn't have to be a perfect metric, it just
needs to be a meaningful and repeatable one.
