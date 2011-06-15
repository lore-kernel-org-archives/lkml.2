Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1FOCii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:38:38 -0400
Received: from linux-sh.org ([111.68.239.195]:36685 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1FOCih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:38:37 -0400
Date: Wed, 15 Jun 2011 11:37:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: pjones@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] EFIFB: Fix error handling
Message-ID: <20110615023718.GK17891@linux-sh.org>
References: <20110615003817.18883.41030.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615003817.18883.41030.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 01:38:17AM +0100, David Howells wrote:
> Fix the error handling in the EFIFB driver if platform_driver_probe() fails.
> In that case, the code will pass the driver struct to the _device_
> unregistration function.  It presumably should pass a pointer to the device
> struct instead.
> 
> The compiler gives the following warning to indicate this:
> 
> drivers/video/efifb.c: In function 'efifb_init':
> drivers/video/efifb.c:544:3: warning: passing argument 1 of 'platform_device_unregister' from incompatible pointer type
> include/linux/platform_device.h:40:13: note: expected 'struct platform_device *' but argument is of type 'struct platform_driver *'
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Peter Jones <pjones@redhat.com>
> cc: linux-fbdev@vger.kernel.org
> cc: stable@kernel.org

Thanks, I've already queued a fix for this.
