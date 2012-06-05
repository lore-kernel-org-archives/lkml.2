Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465Ab2FEJdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:33:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42870 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2FEJdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:33:19 -0400
Date: Tue, 5 Jun 2012 18:33:14 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 1/2] mtip32xx: Remove 'registers' and 'flags' from sysfs
Message-ID: <20120605093314.GC21560@kroah.com>
References: <4FCD0FC7.9010105@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCD0FC7.9010105@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 12:43:03PM -0700, Asai Thambi S P wrote:
> 
> This patch removes entries 'registers' and 'flags' from sysfs. Updated ABI file
> to reflect this change.
> 
> Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>

Much nicer, thanks for doing this:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

But, one question on a different sysfs file:

>  What:           /sys/block/rssd*/status
>  Date:           April 2012
>  KernelVersion:  3.4
>  Contact:        Asai Thambi S P <asamymuthupa@micron.com>
>  Description:    This is a read-only file. Indicates the status of the device.

What "status" is this showing?  Why is this a sysfs file?  Who
needs/wants it?

Also, if you really want to properly create sysfs files, use the default
attributes for the driver.  As it is, you are creating them after
userspace is notified about the device showing up, which races with the
creation of your additional file(s).  Use the properly driver core field
to have the core create, and remove them, automatically, which saves you
code, and fixes bugs you didn't realize you had :)

thanks,

greg k-h
