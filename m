Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2ALVjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:39:09 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43042 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873Ab2ALVjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:39:04 -0500
X-Sasl-enc: 14ckSsaVNMbHPrFUJgH7ybPkxw1U8lKno7wyPXuD4utn 1326404343
Date: Thu, 12 Jan 2012 13:38:30 -0800
From: Greg KH <greg@kroah.com>
To: Paul Taysom <taysom@chromium.org>
Cc: Paul Taysom <taysom@google.com>, Mandeep Baines <msb@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Theodore Tso <tytso@google.com>, Andrew Morton <akpm@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
Message-ID: <20120112213830.GB17405@kroah.com>
References: <1326402935-31002-1-git-send-email-taysom@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326402935-31002-1-git-send-email-taysom@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 01:15:35PM -0800, Paul Taysom wrote:
> From: Paul Taysom <taysom@google.com>
> 
> A USB stick with a ext file system on it, would occasionally crash
> when the stick was pulled.
> 
> The problem was a timer was being set on the Backing Device Interface,
> bdi, after the USB device had been removed and the bdi had been
> unregistered. The bdi would then be later reinitialized by zeroing
> the timer without removing from the timer from the timer queue.
> This would eventually result in a kernel crash (NULL ptr dereference).
> 
> When the bdi is unregistered, the dev field is set to NULL. This
> indication is used by bdi_unregister to only unregister the device
> once.
> 
> Fix: When the backing device is invalidated, the mapping backing_dev_info
> should be redirected to the default_backing_dev_info.
> 
> Created 3 USB sticks with ext2, ext4 and one with both apple and DOS
> file systems on it. Inserted and removed USB sticks many times in random
> order. With out the bug fix, the kernel would soon crash. With the fix,
> it did not. Ran on both stumpy and amd64-generic.
> 
> Change-Id: Icdd06cf3ced555dcd9994cfcc9478a9071a802f1

What is this field for?  It makes no sense for a kernel patch
submission.

> Signed-off-by: Paul Taysom <taysom@chromium.org>
> Downstream-bug-report: http://crosbug.com/24165

Is that a regular field that we now use?

And shouldn't this go to the stable kernel releases as well?

Third time's a charm?

greg k-h
