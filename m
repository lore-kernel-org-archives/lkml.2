Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2ISHRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:17:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53089 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab2ISHRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:17:51 -0400
X-Sasl-enc: /Mmx5pzlSMJps+eU3Zpi4pX4wkr/3UE6/Wx9QghGMMAn 1348039070
Date: Wed, 19 Sep 2012 08:17:48 +0100
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20120919071748.GD16905@kroah.com>
References: <20120919143136.46dd2318963c0d8524492041@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919143136.46dd2318963c0d8524492041@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 02:31:36PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/usb/serial/vizzini.c: In function 'vizzini_set_termios':
> drivers/usb/serial/vizzini.c:454:22: error: invalid type argument of '->' (have 'struct ktermios')
> 
> Caused by commit c05fecb1d57e ("USB: serial: add vizzini driver")
> interacting with commit adc8d746caa6 ("tty: move the termios object into
> the tty") from the tty tree.
> 
> I added the following merge fix patch and can carry it as necessary:

Looks correct to me, thanks for this, a side affect of api changes in
the tty tree at the moment.

greg k-h
