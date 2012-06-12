Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2FLSHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:07:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43854 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2FLSHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:07:13 -0400
Date: Tue, 12 Jun 2012 11:07:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Chan <benchan@chromium.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sage Ahn <syahn@gctsemi.com>
Subject: Re: [PATCH v2] staging: gdm72xx: Fix spinlock recursion on
 gdm_usb_send_complete
Message-ID: <20120612180709.GA9775@kroah.com>
References: <1339522852-28066-1-git-send-email-benchan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339522852-28066-1-git-send-email-benchan@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 10:40:52AM -0700, Ben Chan wrote:
> This patch fixes a spinlock recursion bug on several call sites of
> gdm_usb_send_complete by not calling spin_lock_irqsave on
> urb->context->tx_cxt->lock when the lock has already been acquired.
> 
> Signed-off-by: Ben Chan <benchan@chromium.org>
> Cc: Sage Ahn <syahn@gctsemi.com>
> ---
> This revised patch simplifies the previous patch.

Argh, I _just_ applied the previous patch :(

Care to send me an incremental one, fixing it up to look like this now
so I don't have to revert your previous one?

thanks,

greg k-h
