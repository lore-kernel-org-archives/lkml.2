Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab1GaWe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:34:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:33777 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1GaWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:34:50 -0400
Subject: Re: [PATCH] kbuild: honor the ARCH setting of the existing
 configuration
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Sun, 31 Jul 2011 23:34:45 +0100
In-Reply-To: <CACqU3MXak0Yo+VDQNEqT9rTJ5CjdU6jJ-C1Km7GauMQ+qGW+vg@mail.gmail.com>
References: <1312141497-13854-1-git-send-email-lacombar@gmail.com>
	 <1312143643.12369.32.camel@i7.infradead.org>
	 <CACqU3MXak0Yo+VDQNEqT9rTJ5CjdU6jJ-C1Km7GauMQ+qGW+vg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312151687.18010.31.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 18:07 -0400, Arnaud Lacombe wrote:
> I think you totally miss the point of the patch as you keep being
> self-centered on x86.

I'm focusing on x86 at the moment because x86 is the only architecture
that's *broken* in this respect. The other architectures that you
mention below, where they support 64-bit kernels, all work fine with
only *one* ARCH= setting covering all configurations. It's only x86
where we haven't actually *finished* the merge.

> I am working with configuration for mips, sh, powerpc, arm and x86.
> Some of them are for real board, some of them are to regress-test
> compilers, binutils and kernel builds. Each of those config hardcode
> the CROSS_COMPILER string and have their own build directory. In each
> case, I want to be able to just run "make O=/src/obj/v3.0-arm
> oldnoconfig all" without having to worry about anything else.

Yes, that's a valid but *separate* problem. FWIW I usually solve this
problem with a two-line GNUmakefile:
	ARCH := arm
	include Makefile

I haven't checked whether it works for out-of-source-tree builds; I bet
it could be made to.

I would love to see $ARCH turned into a proper configuration option. 

-- 
dwmw2

