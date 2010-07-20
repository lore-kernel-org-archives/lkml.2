Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0GTHfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:35:08 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:59256 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab0GTHfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:35:05 -0400
Date: Tue, 20 Jul 2010 09:34:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-sh@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] math-emu: correct test for downshifting fraction in
 _FP_FROM_INT()
Message-ID: <20100720093459.10f0ea90@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <19524.52658.716540.932975@pilspetsen.it.uu.se>
References: <19524.51858.992299.119315@pilspetsen.it.uu.se>
	<19524.52658.716540.932975@pilspetsen.it.uu.se>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 00:12:02 +0200
Mikael Pettersson <mikpe@it.uu.se> wrote:

> Unfortunately it seems difficult to write a generic module
> which uses math-emu:
> - <math-emu/soft-fp.h> includes <asm/sfp-machine.h>,
>   but only a handful of archs have it
> - <asm/sfp-machine.h> isn't always self-contained and may depend
>   on various $arch-specific declarations being present
> 
> The given test module works on sparc64 and ppc64, where it uses
> the kernel's sfp-machine.h, and on x86 where it uses a stub
> sfp-machine.h supplied by itself.  I tried to cross-compile it
> for alpha, but that failed due to its sfp-machine.h not being
> self-contained.  I didn't try sh or s390.

It would be challange to try this on s390. The math emulation code is
only used for really old 31 bit machines. Starting with the G5 the fpu
can do IEEE754, I would say the math emulation code is irrelevant for
s390 by now.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

