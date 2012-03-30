Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968Ab2C3PaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:30:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64303 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2C3PaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:30:18 -0400
Date: Fri, 30 Mar 2012 08:30:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: arnd@arndb.de, viro@zeniv.linux.org.uk, davej@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
Message-ID: <20120330153013.GC18488@kroah.com>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 01:04:27PM -0400, Sasha Levin wrote:
> There are no size checks in kmsg_write(), and we try allocating enough
> memory to store everything userspace gave us, which may be too much for
> kmalloc to allocate.

Really?  Have you seen this fail?  As only root can do this, is this
really a problem?

> One option would be to limit it to something, but we can't come up with
> a number that would make sense.
> 
> Instead, just use vmalloc so that nothing would break with large amounts
> of data.

Are you sure this will work properly?  Have you tested it with large
amounts of data?

thanks,

greg k-h
