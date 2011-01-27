Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1A0S37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:29:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1A0S36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:29:58 -0500
Date: Thu, 27 Jan 2011 23:59:44 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Message-ID: <20110127182916.GA4688@amit-x200.redhat.com>
References: <20110120174910.GA30124@kroah.com>
 <1295546625-30681-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295546625-30681-1-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Jan 20 2011 [10:03:43], Greg Kroah-Hartman wrote:
> As requested by Arnd Bergmann, the hvc drivers are now
> moved to the drivers/tty/hvc/ directory.  The virtio_console.c driver
> was also moved, as it required the hvc_console.h file to be able to be
> built, and it really is a hvc driver.

I just saw this now as a result of this patch entering mainline.  I
would have liked to be CC'ed to the patches.  Also, I don't like the
move of the virtio_console.c file to drivers/tty/hvc.  virtio_console.c
is not only an hvc driver; one of its functions is to hook some ports to
hvc, but it's mostly a generic driver these days.

(I also note the MAINTAINERS entry was ignored and not updated in the
3rd patch of this series.)

Can you please move it back?

I could perhaps think of a way of splitting the file so the hvc bits can
be moved to drivers/tty/hvc/ and having the core stay in drivers/char/,
but that'll have to wait for the next cycle.

		Amit
