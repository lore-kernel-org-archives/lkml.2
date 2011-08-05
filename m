Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1HEPSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:18:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab1HEPSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:18:05 -0400
Date: Fri, 5 Aug 2011 08:17:47 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: wfp5p@virginia.edu, linux-kernel@vger.kernel.org
Subject: Re: Staging: serqt_usb2: kmalloc(GFP_NOIO) with spinlock held in
 qt_break() and qt_tiocmset()
Message-ID: <20110805151747.GB18527@suse.de>
References: <4E3BFF9E.9060504@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3BFF9E.9060504@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 06:35:10PM +0400, Alexey Khoroshilov wrote:
> qt_break() calls usb_control_msg() with spinlock held,

Ick, not good, that will sleep.

> while usb_control_msg() calls kmalloc(GFP_NOIO) and indirectly usb_alloc_urb(GFP_NOIO).

You forgot the obvious call to wait_for_completion_timeout() in the
usb_control_msg() callchain that shows that a spinlock is not a good
thing to be using here :)

> The same is true for qt_tiocmget() and qt_tiocmset().
> 
> Is replacing spinlock with mutex an appropriate solution to fix the issue?

Yes, it sounds like it.

patches gladly accepted.

thanks,

greg k-h
