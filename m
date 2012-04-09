Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2DIRoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:44:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2DIRoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:44:10 -0400
Date: Mon, 9 Apr 2012 10:44:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_uart: Fix dma channel unallocated issue
Message-ID: <20120409174405.GA25990@kroah.com>
References: <1332842162-26113-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332842162-26113-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 06:56:02PM +0900, Tomoya MORINAGA wrote:
> This driver anticipates pch_uart_verify_port() is not called
> during installation.
> However, actually pch_uart_verify_port() is called during
> installation.
> As a result, memory access violation occurs like below.
> 
> 0. initial value: use_dma=0
> 1. starup()
>     - dma channel is not allocated because use_dma=0
> 2. pch_uart_verify_port()
>     - Set use_dma=1
> 3. UART processing acts DMA mode because use_dma=1
>      - memory access violation occurs!
> 
> This patch fixes the issue.
> 
> Solution:
> Whenever pch_uart_verify_port() is called and then
> dma channel is not allocated, the channel should be allocated.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
>  drivers/tty/serial/pch_uart.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

This patch does not apply to 3.4-rc2, so I can not apply it, sorry.

Care to redo it?

greg k-h
