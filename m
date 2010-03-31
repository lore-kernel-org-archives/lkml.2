Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0CaWcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:32:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:39348 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259Ab0CaWcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:32:39 -0400
Subject: Re: start_kernel(): bug: interrupts were enabled early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB3B4DB.7040904@kernel.org>
References: <20100325194100.GA2364@debian>
	 <20100331134048.da4e35a7.akpm@linux-foundation.org>
	 <4BB3B4DB.7040904@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 09:31:27 +1100
Message-ID: <1270074687.7101.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 13:47 -0700, Yinghai Lu wrote:
> > perhaps the second one isn't needed?  Perhaps no architecture
> requires
> > that local interrupts be disabled across the above initialisations?
>         
> spin_unlock_irq from arm is different from other archs?

No, it's not, it will enable IRQs and thats illegal to do so early
during boot. We've been over that one again and again, the problem is
that people want to keep using that instead of irqsave/restore because
it's a nano-optimisation on x86... oh well...

Cheers,
Ben.


