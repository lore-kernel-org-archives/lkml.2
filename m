Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1IBNxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:53:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39068 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752056Ab1IBNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:53:16 -0400
Date: Fri, 2 Sep 2011 09:53:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
In-Reply-To: <CACVXFVO6PhfgH_90B7AvWxSReCeJJ8D+jpgrk065MPHok7jzhA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109020948410.1967-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011, Ming Lei wrote:

> >> I am not sure if there are other devices except for EHCI(maybe have uhci/ohci).
> >
> > Yes: UHCI, OHCI, EHCI, and XHCI all poll memory constantly.
> 
> In fact, the flush may be not required for ohci and xhci case, since there is
> already one mmio register writing at the end of .enqueue path in ohci/xhci
> driver.(just a glance at the code of ohci/xhci, please correct if I am wrong)

I don't know about xhci, but you're right about ohci.  However, there's 
no guarantee that the mmio write will always remain there; somebody 
might change the code so that the write takes place only when it is 
needed instead of every time.

> For UHCI, looks like it has not been used on ARM, so maybe can ignore it.
> UHCI is to support a slow usb 1.1 transfer, so I am wondering if the flush
> can produce a obvious performance boost.

Believe me, even with USB-1.1 a 20-ms delay will be noticeable.

> So looks like the flush only makes sense on EHCI.

Assuming ARM is the only architecture that needs it.

> If the above is not wrong, is it really needed to introduce a general DMA API
> only for EHCI?

Maybe not.  I'm hoping that people will identify the underlying cause
for these delayed write-backs and fix it.  Then no changes at all would
be needed in the USB stack.

Alan Stern

