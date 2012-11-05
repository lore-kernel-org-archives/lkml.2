Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab2KEVMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:12:03 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:60784 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab2KEVMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:12:01 -0500
Date: Tue, 6 Nov 2012 01:11:59 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: connector and netlink_broadcast (semop failed for cookie ...)
Message-ID: <20121105211159.GA4894@ioremap.net>
References: <509816A8.70005@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509816A8.70005@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Nov 05, 2012 at 08:42:32PM +0100, Alexander Holler (holler@ahsoftware.de) wrote:
> Could it be the case that cn_netlink_send() has to ignore the same
> return codes as done in kobject_uevent_env()? Or maybe the users of
> cn_netlink_send() have to ignore them?

We just do not know what to do with that error.
Pretty much it means nothing can be done about it.
There is no recovery path, no collection and resend, since it may lead to dos.

Its like knowing that udp packet get lost, but you do not have enough
buffer space to save it and block. Actually there is no buffer at all.
Kind of missed interrupt.

-- 
	Evgeniy Polyakov
