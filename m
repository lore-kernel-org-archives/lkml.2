Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0IMMMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:12:55 -0400
Received: from bar.sig21.net ([80.81.252.164]:47239 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab0IMMMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:12:54 -0400
Date: Mon, 13 Sep 2010 14:12:47 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Robin Theunis <robint91@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-embedded@vger.kernel.org
Subject: Re: ARM target not boot after remap memory
Message-ID: <20100913121247.GA4003@sig21.net>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.585,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 01:25:26PM +0200, Robin Theunis wrote:
> 
> Uncompressing Linux... done, booting the kernel.
> ---
> 
> Here is stalls. With my jtag probe I can locate the problem.
> 
> ---
> > halt
> target state: halted
> target halted in ARM state due to debug-request, current mode: Supervisor
> cpsr: 0x600000d3 pc: 0xc000af3c
> MMU: enabled, D-Cache: enabled, I-Cache: enabled
> >   arm disassemble 0xc000af3c
> 0xc000af3c	0xeafffffe	B 0xc000af3c
> ---
> 
> This just loops at that address. Why does it that?

Maybe it panicked but you can't see the message since
you have not enabled EARLY_PRINTK.

Since you have JTAG, you could also dump the printk
buffer __log_buf to see the message.


HTH
Johannes
