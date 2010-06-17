Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab0FQUpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:45:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40255 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760723Ab0FQUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:45:38 -0400
Date: Thu, 17 Jun 2010 21:49:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Howard Chu <hyc@symas.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
Message-ID: <20100617214915.3478e501@lxorguk.ukuu.org.uk>
In-Reply-To: <4C1A7F72.6020907@symas.com>
References: <E1OObIu-0004K2-3K@lirone.symas.net>
	<20100615202924.24446d28@lxorguk.ukuu.org.uk>
	<4C17DA85.40803@symas.com>
	<4C1A7F72.6020907@symas.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> For Alpha this value should match OSF if possible.
> 
> OSF didn't define this flag, nor did it assign that particular bit to any 
> purpose. Is that good enough?

Fine

> > Are you suggesting that this is completely unfixable/unworkable? Would it be
> > sufficient to use kernel_termios_to_user_termios() ?

I don't see a way to fix it sanely

> >
> Actually using kernel_termios_to_user_termios_1(). In all supported 
> architectures this structure is basically aligned with but smaller than the 
> userland struct termios.

The relationship isn't quite so simple and it may change in the future,
so this seems to be a very bad idea. Besides which syscalls are *cheap*
so simply notifying someone to reread the terminal data they care about
should be fine. In that sense it seems SVR4 got it right.

Alan
