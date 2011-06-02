Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1FBOxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:53:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41784 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752198Ab1FBOxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:53:05 -0400
Date: Thu, 2 Jun 2011 10:53:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julia Lawall <julia@diku.dk>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb/gadget/inode.c: add missing kfree
In-Reply-To: <1307003186-23244-1-git-send-email-julia@diku.dk>
Message-ID: <Pine.LNX.4.44L0.1106021035500.1913-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The label fail frees dev->buf, but kbuf hasn't yet been stored there at
> this point.

...

> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> I wonder if it is really correct to free dev->buf at fail in this case.
> Because it is freeing the previously allocated value of dev->buf, not the
> current one as done in subsequent cases.

I don't think it matters.  This check is probably there only for 
safety; it should not be possible for dev->buf to be non-NULL at this 
point.  You ought to be able to remove the entire

	if (dev->buf)
		goto fail;

statement with no ill effects.

Alan Stern

