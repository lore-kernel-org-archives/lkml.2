Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab1FFIjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:39:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52736 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab1FFIjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:39:22 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110605151323.GA30590@elte.hu>
References: <20110605095555.GA22058@elte.hu>
	 <4DEB58D8.4000805@die-jansens.de> <20110605110132.GB23463@elte.hu>
	 <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu>
	 <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu>
	 <4DEB8A93.30601@die-jansens.de> <20110605141003.GB29338@elte.hu>
	 <4DEB933C.1070900@die-jansens.de>  <20110605151323.GA30590@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 10:38:50 +0200
Message-ID: <1307349530.2353.7374.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 17:13 +0200, Ingo Molnar wrote:

> Now, this patch alone just removes a debugging check - but i'm not 
> sure the debugging check is correct - we take the pi_lock in a raw 
> way - which means it's not lockdep covered.

Ever since tglx did s/raw_/arch_/g raw_ is covered by lockdep.
