Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab2CHTOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:14:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab2CHTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:14:40 -0500
Date: Thu, 8 Mar 2012 11:14:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/6] vt: push the tty_lock down into the map handling
Message-ID: <20120308191436.GA30341@kroah.com>
References: <20120302145628.32320.53944.stgit@bob.linux.org.uk>
 <20120302150012.32320.70608.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120302150012.32320.70608.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:00:14PM +0000, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> When we do this it becomes clear the lock we should be holding is the vc
> lock, and in fact many of our other helpers are properly invoked this way.
> 
> We don't at this point guarantee not to race the keyboard code but the results
> of that appear harmless and that was true before we started as well.
> 
> We now have no users of tty_lock in the console driver...
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/tty/vt/consolemap.c |  119 ++++++++++++++++++++++++++++++++-----------
>  drivers/tty/vt/vt_ioctl.c   |   25 ++-------
>  include/linux/vt_kern.h     |    1 
>  3 files changed, 93 insertions(+), 52 deletions(-)
> 

With this patch applied, I get the following build error:

drivers/tty/vt/consolemap.c: In function ‘con_set_trans_old’:
drivers/tty/vt/consolemap.c:315:2: error: implicit declaration of function ‘console_lock’ [-Werror=implicit-function-declaration]
drivers/tty/vt/consolemap.c:323:2: error: implicit declaration of function ‘console_unlock’ [-Werror=implicit-function-declaration]

what went wrong?

I've applied the first 5 in this series to my tree now, but not this
one.

thanks,

greg k-h
