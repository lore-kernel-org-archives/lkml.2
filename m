Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab2BWWti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:49:38 -0500
Received: from 1wt.eu ([62.212.114.60]:62582 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab2BWWtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:49:36 -0500
Date: Thu, 23 Feb 2012 23:49:27 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223224927.GC1306@1wt.eu>
References: <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com> <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com> <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com> <20120223215242.GA1306@1wt.eu> <CA+55aFyxB4kmmSOKDSRkAkaRx=G7o7JnuUGBu3_WVr9KbpWWYQ@mail.gmail.com> <20120223222733.GB1306@1wt.eu> <CA+55aFxztx=Cf8i+jZE=X8Zx1BZnNpC6wv-PkWcXDfBFS6qWqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxztx=Cf8i+jZE=X8Zx1BZnNpC6wv-PkWcXDfBFS6qWqg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 02:38:42PM -0800, Linus Torvalds wrote:
> On Thu, Feb 23, 2012 at 2:27 PM, Willy Tarreau <w@1wt.eu> wrote:
> >
> > OK so indeed I will only be able to check that it boots :-/
> 
> Well, we could do some trivial test-harness that just forces the issue
> with regular timer interrupts (and even without AES-NI). I think Peter
> talked about that when we were trying to hunt it down - but I think he
> was then able to reproduce the problem without anything special and we
> dropped it.
> 
> Essentially, just doing something like
> 
>     if (irq_fpu_usable()) {
>         kernel_fpu_begin();
>         kernel_fpu_end();
>     }
> 
> in do_irq() and do_softirq() would stress-test things even without
> wireless, and even without AES-NI.

Interesting...

> You'd still need an x86-32 machine to test on, because x86-64 was
> immune to this issue.
> 
> But yeah, the impact of this seems to be small enough that for older
> kernels (which are likely used on older systems for maintenance
> anyway) disabling AES-NI on x86-32 really might be the way to go.

I agree. I don't know anybody using AES-NI on purpose on older x86-32
systems!

Willy

