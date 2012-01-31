Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2AaOys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:54:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55356 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061Ab2AaOyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:54:46 -0500
X-Sasl-enc: a0LmWsQB8hziBp0g9iDwkc6x7WQb/czGZZfObQHJOYy0 1328021685
Date: Tue, 31 Jan 2012 06:53:32 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: debugfs: fix error check
Message-ID: <20120131145332.GD27352@kroah.com>
References: <1328011431-25610-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328011431-25610-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 02:03:51PM +0200, Felipe Balbi wrote:
> debugfs APIs will return two different error
> values depending on the situation:
> 
>  -> if debugfs isn't enabled in the kernel:
> 	it will return -ENODEV
> 
>  -> if debugfs is enabled in the kernel:
> 	it will return NULL
> 
> This means that blindly using IS_ERR() isn't
> enough and, in fact, will not work on a real
> error condition.
> 
> While we could be checking for a NULL pointer
> only because we only compile and link debugfs.o
> when CONFIG_DEBUG_FS is enabled, we decided
> to play it safe should any of the debugfs rules
> change over time.

The rules should not change over time, and if they do, any in-kernel
users will be fixed up.

This shouldn't be that hard, just check for NULL and move on if an error
happens, don't mess with the IS_ERR() stuff at all.

Look at how the USB core handles this, and use that logic.

thanks,

greg k-h
