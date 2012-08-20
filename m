Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab2HTPgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:36:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50175 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2HTPgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:36:49 -0400
Date: Mon, 20 Aug 2012 16:36:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 7/7] drm/pci: Defer initialization of secondary
 graphics devices until switcheroo is ready
Message-ID: <20120820153640.GA29614@srcf.ucam.org>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
 <1345476664-22066-8-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345476664-22066-8-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:31:04AM -0500, Seth Forshee wrote:
> +	/*
> +	 * For secondary graphics devices shouldn't be initialized
> +	 * until the handler and primary graphics device have been
> +	 * registered with vga_switcheroo.
> +	 *
> +	 * FIXME: Is vga_default_device() reliable enough for this
> +	 * purpose?
> +	 *
> +	 * FIXME: If vga_switcheroo is disabled secondary devices
> +	 * never gets initialized. Is this okay? Maybe it is, since
> +	 * we can't switch to the secondary GPU anyway.
> +	 */

Won't this break the multiple cards with independent outputs case?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
