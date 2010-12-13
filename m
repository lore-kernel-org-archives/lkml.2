Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0LMHdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:33:46 -0500
Received: from ozlabs.org ([203.10.76.45]:57056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0LMHdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:33:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] x86: initialize initial_page_table before paravirt jumps
Date: Mon, 13 Dec 2010 18:03:38 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Borislav Petkov <bbpetkov@yahoo.de>
References: <201012091229.46430.rusty@rustcorp.com.au> <4D011758.6010501@goop.org>
In-Reply-To: <4D011758.6010501@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012131803.39427.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 04:22:24 am Jeremy Fitzhardinge wrote:
> On 12/08/2010 05:59 PM, Rusty Russell wrote:
> > As of v2.6.36-rc8-54-gb40827f, initial_page_table needs to be set up to boot.
> > My initial fix for lguest was to cut & paste in the initialization code, but
> > as it's simply byte-twiddling (which could be done at compile time if we
> > were clever enough), it seems better to do it unconditionally.
> >
> > Jeremy, Ingo does this make sense to you?  Given it's rc5, I have an
> > lguest-specific patch ready as an alternative...
> 
> We have already committed a Xen-specific fix for this (twice!).  Your
> patch is a no-op for Xen because we never ended up using that entry path
> through head_32.S, so if it fixes things for lguest then go for it.

Hmm, I'm going to call that "Acked-by".

But given the late stage in the cycle, I'll put the lguest-only version in
now and submit this for next merge window.

Thanks!
Rusty.
