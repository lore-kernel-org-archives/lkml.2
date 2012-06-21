Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2FUAcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:32:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49312 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2FUAch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:32:37 -0400
Date: Wed, 20 Jun 2012 17:32:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alexis Cortes <alexis.cortes@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120621003232.GD3255@kroah.com>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621000734.GB32743@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 05:07:34PM -0700, Sarah Sharp wrote:
> > Unfortunately there is not a way to programmatically detect if the re-driver
> > is present on the system, and since it might affect any host controller, I'm
> > afraid this workaround can't be limited on the driver to specific hardware. 
> 
> Ok, then make it a module parameter that is off by default.  Users who
> find they have this issue can reload the driver with the timer on, and
> add the module parameter to their grub linux boot line.  If we find that
> the redriver is used always for one particular host vendor/revision,
> we'll add a quirk for it.
> 
> But I really don't want an extra timer running and killing power
> management for hosts that don't need this work around.

I don't want that either, but I really don't want a new module parameter
that no one is going to know that they need to set.

I think the real solution is finding what pci devices this is a problem
with, and using a quirk that way.

thanks,

greg k-h
