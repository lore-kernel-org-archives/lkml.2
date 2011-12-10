Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1LJDej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 22:34:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab1LJDei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 22:34:38 -0500
Date: Fri, 9 Dec 2011 19:32:04 -0800
From: Greg KH <gregkh@suse.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: alan@linux.intel.com, davej@redhat.com, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdc-acm: Kill ACM_READY() macro completely
Message-ID: <20111210033204.GA26402@suse.de>
References: <13234763473078@kroah.org>
 <1323478314-29443-1-git-send-email-hskinnemoen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323478314-29443-1-git-send-email-hskinnemoen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 04:51:54PM -0800, Havard Skinnemoen wrote:
> The ACM_READY() macro doesn't seem to do anything useful, and it may
> prevent tty_wait_until_sent() from working properly when called from
> close.
> 
> Previously, acm_tty_chars_in_buffer() returned 0 whenever
> acm->port.count was 0. This means close() could return before all the
> data has actually been written.
> 
> Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
> ---
> Hi Greg,
> 
> Thanks for picking up  my patch. Unfortunately, it's not completely bug-free.
> 
> This fixes an issue I found while testing the patch: After writing something to
> /dev/ttyACM0, the process would hang for a fairly long time (10-15 seconds)
> when closing the device. This is because port.count drops to 0 before
> tty_wait_until_sent_from_close() is called, which causes ACM_READY() to return
> false, any outstanding writes never get reaped because the workqueue doesn't
> get scheduled, tty_wait_until_sent never sees any progress and eventually times
> out.
> 
> Please feel free to fold this into "cdc-acm: Fix potential deadlock (lockdep
> warning)", or let me know if you want me to send you a v2 of that patch
> instead.

I'll just apply this one, as I can't merge it together as I already
applied it.

thanks,

greg k-h
