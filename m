Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2BWWjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:39:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42368 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2BWWjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:39:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120223222733.GB1306@1wt.eu>
References: <20120222211928.GA4448@kroah.com> <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
 <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com>
 <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com>
 <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com>
 <20120223215242.GA1306@1wt.eu> <CA+55aFyxB4kmmSOKDSRkAkaRx=G7o7JnuUGBu3_WVr9KbpWWYQ@mail.gmail.com>
 <20120223222733.GB1306@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 14:38:42 -0800
X-Google-Sender-Auth: MUv2wC4eu_t5m_psa9KBV1wMrN0
Message-ID: <CA+55aFxztx=Cf8i+jZE=X8Zx1BZnNpC6wv-PkWcXDfBFS6qWqg@mail.gmail.com>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
To: Willy Tarreau <w@1wt.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 2:27 PM, Willy Tarreau <w@1wt.eu> wrote:
>
> OK so indeed I will only be able to check that it boots :-/

Well, we could do some trivial test-harness that just forces the issue
with regular timer interrupts (and even without AES-NI). I think Peter
talked about that when we were trying to hunt it down - but I think he
was then able to reproduce the problem without anything special and we
dropped it.

Essentially, just doing something like

    if (irq_fpu_usable()) {
        kernel_fpu_begin();
        kernel_fpu_end();
    }

in do_irq() and do_softirq() would stress-test things even without
wireless, and even without AES-NI.

You'd still need an x86-32 machine to test on, because x86-64 was
immune to this issue.

But yeah, the impact of this seems to be small enough that for older
kernels (which are likely used on older systems for maintenance
anyway) disabling AES-NI on x86-32 really might be the way to go.

       Linus
