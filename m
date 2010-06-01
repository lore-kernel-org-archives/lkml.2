Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0FADGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:06:11 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43220 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab0FADGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:06:09 -0400
Date: Tue, 1 Jun 2010 12:05:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the  shtree
Message-ID: <20100601030545.GB15411@linux-sh.org>
References: <20100601111149.a809f097.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601111149.a809f097.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 11:11:49AM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the sh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from drivers/usb/gadget/r8a66597-udc.c:35:
> drivers/usb/gadget/r8a66597-udc.h: In function 'r8a66597_read_fifo':
> drivers/usb/gadget/r8a66597-udc.h:147: error: implicit declaration of function 'readsl'
> drivers/usb/gadget/r8a66597-udc.h:164: error: implicit declaration of function 'readsw'
> drivers/usb/gadget/r8a66597-udc.h: In function 'r8a66597_write_fifo':
> drivers/usb/gadget/r8a66597-udc.h:197: error: implicit declaration of function 'writesl'
> drivers/usb/gadget/r8a66597-udc.h:204: error: implicit declaration of function 'writesw'
> In file included from drivers/usb/host/r8a66597-hcd.c:44:
> drivers/usb/host/r8a66597.h: In function 'r8a66597_read_fifo':
> drivers/usb/host/r8a66597.h:185: error: implicit declaration of function 'readsl'
> drivers/usb/host/r8a66597.h:194: error: implicit declaration of function 'readsw'
> drivers/usb/host/r8a66597.h: In function 'r8a66597_write_fifo':
> drivers/usb/host/r8a66597.h:215: error: implicit declaration of function 'writesl'
> drivers/usb/host/r8a66597.h:230: error: implicit declaration of function 'writesw'
> 
> Caused by commits 920491717d4729844a6ebcd13c863e163d41ca6e ("usb: gadget:
> r8a66597-udc pio to mmio accessor conversion") and
> ae7cbc543c96c90d3b277a5370d77c08a047c396 ("usb: r8a66597-hcd pio to mmio
> accessor conversion").
> 
I thought those were standard, but it seems not. I'll switch over to the
ioread/write_rep() ones instead, thanks.
