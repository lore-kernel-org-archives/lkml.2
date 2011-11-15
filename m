Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1KOUWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:22:24 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56871 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064Ab1KOUWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:22:13 -0500
X-Sasl-enc: JBZ3e2g7NLo3S1AwrKdYhXdQQSGiXrUfs/Qs6bkBphQ5 1321388533
Date: Tue, 15 Nov 2011 12:21:47 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tty: make several fops functions non-static so that
 the pty code can use them
Message-ID: <20111115202147.GA25654@kroah.com>
References: <20111030094038.7046d529@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111030094038.7046d529@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 09:40:38AM -0700, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The pty code currently does a partial function-pointer copy to fill its
> struct file_operations; this patch makes the functions it copies non-static
> in preparation of switching the pty code over to using proper prototypes.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

With this patch, I get the following build error:

drivers/tty/tty_io.c:2712:13: error: static declaration of ‘tty_compat_ioctl’ follows non-static declaration
include/linux/tty.h:492:13: note: previous declaration of ‘tty_compat_ioctl’ was here
drivers/tty/tty_io.c:2712:13: warning: ‘tty_compat_ioctl’ defined but not used

Please fix up the series and resend them, in a format that I can apply
them in, without having to edit the body of the patch by hand.

thanks,

greg k-h
