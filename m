Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1D0QZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:25:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36118 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754024Ab1D0QZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:25:41 -0400
Date: Wed, 27 Apr 2011 12:25:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rabin Vincent <rabin@rab.in>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        <linux-kernel@vger.kernel.org>, <gcc@gcc.gnu.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
In-Reply-To: <BANLkTimxLjvq2GC8_TJJk9OXZ9fPc-JKiA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104271224030.2239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, Rabin Vincent wrote:

> On Wed, Apr 27, 2011 at 00:21, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 26 Apr 2011, Rabin Vincent wrote:
> >> In my case it's this writel() in ehci-hub.c that gets chopped into
> >> strbs:
> >>
> >>       /* force reset to complete */
> >>       ehci_writel(ehci, temp & ~(PORT_RWC_BITS | PORT_RESET),
> >>                               status_reg);
> >
> > Why would that get messed up?  The status_reg variable doesn't have any
> > __atribute__((packed)) associated with it.
> 
> The initialization of status_reg is:
> 
> 	u32 __iomem *status_reg
> 		= &ehci->regs->port_status[(wIndex & 0xff) - 1];
> 
> where ehci->regs is a pointer to the packed struct ehci_regs.  So, this
> is the same problem of casting pointers to stricter alignment.

Right.  I can understand the compiler complaining about the cast to 
stricter alignment during the initialization.  But I don't understand 
why that would affect the code generated for the writel function.

Alan Stern

