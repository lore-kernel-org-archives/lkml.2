Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0DZSNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:13:24 -0400
Received: from kroah.org ([198.145.64.141]:40665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab0DZSNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:13:22 -0400
Date: Mon, 26 Apr 2010 11:11:52 -0700
From: Greg KH <greg@kroah.com>
To: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       usbip-devel@lists.sourceforge.net,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Subject: Re: zero copy in usbip send and recieve path
Message-ID: <20100426181152.GB23986@kroah.com>
References: <i2kf74c922b1004260357x6548f7ddz6e0a38fafa4f54ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i2kf74c922b1004260357x6548f7ddz6e0a38fafa4f54ce@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 04:27:46PM +0530, B.Vinai Kumar wrote:
> Hi All,
> 
> I'am trying to implement zero copy in USBIP while sending / receiving
> usbip packets.
> 
> I started it with send path. The device which I used is mass storage.
> I'am using linux kernel 2.6.15.

2.6.15 is _very_ old, and not supported by anyone.  You might try this
on a more modern kernel release, like 2.6.33 or newer.

> After virtualization, once the file copy starts from device to pc each
> usbip packet carries payload of 64K.
> 
> I'am allocating this 64K buffer through __get_free_pages() (with order
> 4) and assigning the buffer pointer to urb. After completion of URB
> i'am trying to send this buffer page by page by using tcp_sendpage
> instead of calling kernel_sendmsg(), this is to avoid copy which is
> done in the TCP send path.
> 
> By doing this way it is able to send the buffer successfully, but I'am
> not finding the way to free this buffer. This copy continues until the
> entire memory is consumed.

After you are done with the memory, you need to explicitly free it, why
can't you do that?

> who will free this buffer?

You need to.

> 1) If i call free_pages for entire 64K right after tcp_sendpage (i.e
> after sending all the pages, 64K). then observed
> the Kernel panic. It is obvious that the tcp core is not yet finished its job.
> 
> 2) TCP core is also not freeing these pages.
> 
> This might be because, I allocated 64K buffer at once and trying to
> free it page by page.
> 
> I need some help to resolve this issue.
> 
> Performance wise there is a huge jump in throughput.

Are you sure?  The bandwith issue should be on the usb device side, not
the network from what I have seen.  What type of device are you testing
this with?

thanks,

greg k-h
