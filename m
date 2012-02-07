Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2BGA0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:26:35 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46304 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353Ab2BGA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:26:33 -0500
X-Sasl-enc: cKV/IE1jFS+DERC8+acaXMbFHTcvhsacnBKHVU3KyCUj 1328574392
Date: Mon, 6 Feb 2012 16:15:58 -0800
From: Greg KH <greg@kroah.com>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] char/mem: Make /dev/port less obviously broken (v0)
Message-ID: <20120207001558.GA30840@kroah.com>
References: <1328569322-19165-1-git-send-email-ajax@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328569322-19165-1-git-send-email-ajax@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 06:02:02PM -0500, Adam Jackson wrote:
> Did you know /dev/port turns all reads and writes into a stream of inb
> and outb?  Turns out hardware really does care about I/O cycle size
> though, and if you're trying to do an outl four outb's is very much not
> the same thing.
> 
> However, someone somewhere probably built some code and hardware that
> relies on that behaviour.  Plus, userspace needs to be able to tell
> whether the kernel will do the right thing, and fall back to raw port
> access if not.  So add an ioctl to request new 'strict' semantics, which
> allows only exactly 1/2/4 byte cycles and translates them into the
> corresponding I/O cycle size.  This matches the behaviour of sysfs's
> resourceN files for I/O BARs.

Who would use this new ioctl?  And if it's been working ok until now,
why is it needed?

If you want something "new" like this, why not just create /dev/ioport
or something like that to always use the proper alignment and not need
an ioctl at all?

thanks,

greg k-h
