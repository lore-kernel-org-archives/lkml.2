Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab0EZT4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:56:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46785 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab0EZT4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:56:12 -0400
Date: Wed, 26 May 2010 21:56:06 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526215606.2a747c61@schatten.dmk.lab>
In-Reply-To: <20100526190204.5efe4d59@lxorguk.ukuu.org.uk>
References: <20100526171106.0e44a736@schatten.dmk.lab>
	<alpine.LFD.2.00.1005261829540.2995@localhost.localdomain>
	<20100526190204.5efe4d59@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 19:02:04 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > The power efficiency of a mobile device is depending on a sane overall
> > software stack and not on the ability to mitigate crappy software in
> > some obscure way which is prone to malfunction and disappoint users.
> 
> Even if you believe the kernel should be containing junk the model that
> works and is used for everything else is resource management. Not giving
> various tasks the ability to override rules, otherwise you end up needing
> suspend blocker blockers next week.
> 
> A model based on the idea that a task can set its desired wakeup
> behaviour *subject to hard limits* (ie soft/hard process wakeup) works
> both for the sane system where its elegantly managing hard RT, and for
> the crud where you sandbox it to stop it making a nasty mess.
> 
> Do we even need a syscall or will adding RLIMIT_WAKEUP or similar do the
> trick ?
> 
> Alan

Your approach definitely sounds better than the current solution. 
What about mapping suspend blocker functionality later on, when this
interface exists, on to this new approach and deprecating it?

Cheers,
Flo
