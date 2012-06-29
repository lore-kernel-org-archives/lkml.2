Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2F2HZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:25:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47556 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2F2HZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:25:04 -0400
Date: Fri, 29 Jun 2012 10:24:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Zoltan Kelemen <zoltan@digisec.se>
Cc: willy@meta-x.org, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging:panel: Rewrite for fixing synchronization
 issues
Message-ID: <20120629072441.GN5333@mwanda>
References: <4FECC539.8040303@digisec.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FECC539.8040303@digisec.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 10:57:29PM +0200, Zoltan Kelemen wrote:

> Partial rewrite of panel driver to make it more robust. The old code contains
> problems potentially leading to kernel oops, deadlocks and memory leaks.
> 
> The patch contains the following changes:
> * Handle asynchronous attach/detach to/from parport.
> * Proper synchronization of multiple opens to same device.
> * Proper disabling of softirqs when locking pprt from user context.
> * Replaced interruptible_sleep_on in keypad_read to avoid race conditions.
> * Changed to del_timer_sync to make sure timer function finishes before
>   unloading module.
> * Added owner to file_operations to avoid module being unloaded with dangling
>   opens.
> * Check status of user-mode memory write in keypad_read.
> * Check for and handle errors in keypad_init.
> * Properly free memory for logical_inputs to avoid memory leak on unload.
> 

Gar...  Don't do this.  :/  Each bullet point here should be a
separate patch.  Please break it apart and resend.

Put the white space changes and the declaration reshuffles in their
own patch.

Do not create lock_pprt() and unlock_pprt() functions.  It doesn't
save any lines of code.  It means that Sparse is unable check for
locking bugs.  It hides information pointlessly so it's considered
bad style.  The comment is nice though and that should go next to
the declaration of the "pprt_lock" spinlock.

regards,
dan carpenter


