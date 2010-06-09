Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0FIWf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:35:26 -0400
Received: from kroah.org ([198.145.64.141]:60120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0FIWfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:35:25 -0400
Date: Wed, 9 Jun 2010 15:34:31 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/1] PCI: hotplug/cpqphp, fix NULL dereference
Message-ID: <20100609223431.GD2533@kroah.com>
References: <1276115473-2307-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276115473-2307-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 10:31:13PM +0200, Jiri Slaby wrote:
> There are devices out there which are PCI Hot-plug controllers with
> compaq PCI IDs, but are not bridges, hence have pdev->subordinate
> NULL. But cpqphp expects the pointer to be non-NULL.
> 
> Add a check to the probe function to avoid oopses like:
> BUG: unable to handle kernel NULL pointer dereference at 00000050
> IP: [<f82e3c41>] cpqhpc_probe+0x951/0x1120 [cpqphp]
> *pdpt = 0000000033779001 *pde = 0000000000000000
> ...
> 
> The device here was:
> 00:0b.0 PCI Hot-plug controller [0804]: Compaq Computer Corporation PCI Hotplug Controller [0e11:a0f7] (rev 11)
> 	Subsystem: Compaq Computer Corporation Device [0e11:a2f8]
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg KH <greg@kroah.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
