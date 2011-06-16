Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab1FPTqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:46:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48683 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757970Ab1FPTqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:46:42 -0400
Date: Thu, 16 Jun 2011 15:46:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alexander Holler <holler@ahsoftware.de>
cc: Arnd Bergmann <arnd@arndb.de>, <gregkh@suse.de>,
        Rabin Vincent <rabin@rab.in>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <4DFA58B4.5030101@ahsoftware.de>
Message-ID: <Pine.LNX.4.44L0.1106161541260.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Alexander Holler wrote:

> >> I thought the compiler was not allowed to insert
> >> padding if the natural alignment of the data types didn't require any.
> >
> > It's architecture dependent. The alignment of the structure is the maximum alignment
> > of its members, so it gets to be 8 bytes if there is a 64 bit member in the struct
> > on most architectures, but 4 bytes on x86.
> 
> Hmm, sorry, but that sentence just says something about the alignment of 
> the structure itself and nothing about the alignment of it's members or 
> do I understand something wrong?

We're talking about padding, not alignment.  Obviously these two
concepts are related, since fields with differing alignment
requirements sometimes force the compiler to insert padding.  But they
aren't the same thing.

The question is whether gcc will insert padding in a structure that 
doesn't need it.  The kernel depends on peculiarities of gcc in many 
ways; basing your strategy on what the C99 spec says is not always a 
good idea.

> For me that means that I understand that when packed(,aligned(4)) is 
> used, it's pretty sure, that there is no padding inbetween the members 
> of e.g. struct ehci_regs. But without I'm unsure, so I would avoid that.
> 
> That aligned(4) is necessary (for ARM) is only a workaround because of 
> the implementation of readl(), at least that is how I understood the 
> discussion. But that is discussed elsewhere and don't want to take part 
> in that discussion (and can't).

Hmmm.  I won't say that ((packed,aligned(4))) is wrong.  But it's not 
clearly necessary either.

Alan Stern

