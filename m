Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2HOUOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:14:33 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:39462 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2HOUO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:14:29 -0400
Date: Wed, 15 Aug 2012 22:14:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] scripts/modpost: add a exception for USB gadget
	drivers
Message-ID: <20120815201426.GA6902@merkur.ravnborg.org>
References: <1345060759-18091-1-git-send-email-bigeasy@linutronix.de> <1345060759-18091-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345060759-18091-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 09:59:12PM +0200, Sebastian Andrzej Siewior wrote:
> The "driver" struct for a gadget driver is named *_driver. On module
> load, the gadget expects a UDC driver to be loaded and avaiable. If this
> is not the case => -ENODEV and bye bye. That means that the gadget
> driver is initialized immediately. The initialization process includes
> calling ->bind() for the gadget driver. Therefore it is okay to put this
> in __init. It will never be called again, we don't (yet) allow two
> gadgets of the same kind to be ->bind() again.
> 
> Commit 07a18bd716 ("usb gadget: don't save bind callback in struct
> usb_composite_driver") move the ->bind() member from the struct to an
> argument.
> I'm reverting this and adding this exception. For g_zero we save around
> 400bytes. I'm not having the conversion about how important it is to
> save 400 bytes. I wait for configfs interface for the gadget subsystem.
> This will remove the __init from the ->bind() because we will be able to
> call ->bind() more than once and _after_ the init has been dropped.

Could you use the __ref / __refdata annotation?
This would be much cleaner than this hack in modpost.

	Sam
