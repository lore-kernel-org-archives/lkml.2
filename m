Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3AHFwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:52:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37935 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3AHFwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:52:09 -0500
Date: Mon, 7 Jan 2013 21:52:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harvey Yang <harvey.huawei.yang@gmail.com>
Cc: Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] staging: usbip: refine the lock
Message-ID: <20130108055234.GB4561@kroah.com>
References: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 01:49:00PM +0800, Harvey Yang wrote:
> This patchset refines some spinlocks which maybe not used properly.  
> 
> [PATCH 1/2]: The function 'usbip_event_add()' may be called in interrupt context on the stub side: 
> 'stub_complete'->'stub_enqueue_ret_unlink'->'usbip_event_add'.
> In this function it tries to get the lock 'ud->lock', so we should disable irq when we get this lock in process context.
> 
> [PATCH 2/2]: On the client side, we have a virtual hcd driver, there actually no hardware interrupts, so we do not need worry about race conditions caused by irq. To achieve a good performance there is no need to use the interrupt safe spinlock. Just replace them with a non interrupt safe version.

This information needs to be in the patches itself, otherwise it will
never be seen.

Also, why do you think this is going to make anything faster?  Have you
measured it?  What are the results?

thanks,

greg k-h
