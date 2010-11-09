Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0KIUtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:49:00 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38498 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab0KIUs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:48:58 -0500
Date: Tue, 9 Nov 2010 12:48:57 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
Message-ID: <20101109204857.GT5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109181525.GH5876@outflux.net>
 <AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com>
 <20101109191908.GO5876@outflux.net>
 <AANLkTi=zU=RxqMX_h=BM4WchgCbwTi9tWa0SkhxmDwcg@mail.gmail.com>
 <20101109195622.GR5876@outflux.net>
 <AANLkTik3C01Pvv_RvgKXctjKjw=XS4AeEN94ADZtw+sW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik3C01Pvv_RvgKXctjKjw=XS4AeEN94ADZtw+sW@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, Nov 09, 2010 at 10:28:16PM +0200, Pekka Enberg wrote:
> So why can't we do patch 2/4 XD_DISABLE clearing in
> early_init_intel()?

Because it's too late, unfortunately. I went around a few times about this
with Peter Anvin, and ultimately he agreed that it needed to go in
verify_cpu() for now.

> Why do we want to call verify_cpu() from
> arch/x86/kernel/head_32.S and not from
> arch/x86/boot/compressed/head_32.S like we do on 64-bit?

Because the longmode/SSE tests being performed in verify_cpu() need to
happen that early for 64bit. Instead of including it in two places for
32bit, we can just include it once in arch/x86/kernel/head_32.S.

-Kees

-- 
Kees Cook
Ubuntu Security Team
