Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1HRSkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:40:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1HRSkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:40:39 -0400
Date: Thu, 18 Aug 2011 11:37:12 -0700
From: Greg KH <gregkh@suse.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Increase usbfs bulk buffer size
Message-ID: <20110818183712.GC18881@suse.de>
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 07:07:01PM +0200, Markus Rechberger wrote:
> Hi,
> 
> this patch increases the maximum buffersize for bulk transfers, our
> devices support at least up to 46k bytes for bulk transfers.
> This patch allows us to lower the iterations between kernel and
> userspace and lower the system pressure.

But as Oliver pointed out, this increases the memory pressure.  I'm
curious why you say there is "system pressure" with the current buffer
size.  What is the problems here, you are just passing the same logic
issues down to the kernel, that you should be handling in userspace if
you want to use usbfs.

> Signed-off-by: Markus Rechberger <mrechberger@gmail.com>

Also note that this is a user/kernel API that you are changing, are you
_sure_ you didn't just break some user code with this change that was
assuming that the buffer size was 16Kb, as it's been that way for the
past 10 years?

thanks,

greg k-h
