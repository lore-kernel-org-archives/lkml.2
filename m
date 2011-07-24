Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab1GXQQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 12:16:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab1GXQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 12:16:37 -0400
Date: Sun, 24 Jul 2011 09:16:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-Id: <20110724091626.c6829ebe.akpm@linux-foundation.org>
In-Reply-To: <20110724134046.GA10583@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
	<20110724111350.GD21120@elte.hu>
	<20110724134046.GA10583@aftab>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 15:40:46 +0200 Borislav Petkov <bp@amd64.org> wrote:

> > > +	unalias_va_addr
> > > +			[X86-64] Unalias VA address by clearing slice [14:12]
> > > +			1: only on 32-bit
> > > +			2: only on 64-bit
> > > +			off: disabled on both 32 and 64-bit

How much performance difference does this actually make?

> > This says nothing about why it's cleared, what it does and why one 
> > would want to handle it differently on 32-bit and 64-bit.
> 
> This is there in case users care more about the 3bits ASLR granularity
> than invalidations amount, for example.

To make this decision the users will want to know how much their
computers will slow down.  We should tell them.
