Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1CAFq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:46:57 -0500
Received: from kroah.org ([198.145.64.141]:43583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab1CAFqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:46:22 -0500
Date: Mon, 28 Feb 2011 18:52:30 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 4/6] Staging: hv:  Unify the hyperv driver abstractions
Message-ID: <20110301025230.GE1663@kroah.com>
References: <1298686023-30892-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298686023-30892-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 06:07:03PM -0800, K. Y. Srinivasan wrote:
> This patch combines the two driver abstractions into
> a single driver abstraction.

Ah, how sweet.  Unfortunatly you don't say "how" you did this.

Nor do you describe _what_ those two driver abstractions were.  Are we
talking i2c and usb abstractions?  gpio and spi?  Driver core and
platform?  We want to know exactly what is going on here.

Think of writing something that when you look back, in 3 years, while
staring at a Linux hyperv driver originally written for the 2.6.9
kernel, that somehow never got forward ported and you are tasked with
doing this, that you can just do a simple 'git log drivers/staging/hv/'
and instantly know just from the changelog comments exactly what you
need to do to your driver to clean it up and properly get it to work on
the new 8.2.2 kernel release.

This changelog entry, would require you to go and dig through the guts
of the patch itself, trying to figure out what abstractions you are
talking about, and exactly how they were combined, all the while
wondering _why_ they were combined.

Please, think of your future self, you will thank him in the years to
come by doing this properly.  Not to mention making other's lives easier
if you happen to have escaped this dire task by then.

Oh, you have an extra space up there in the subject, please fix it next
time.

> -int blk_vsc_initialize(struct hv_driver *driver)
> +int blk_vsc_initialize(struct driver_context *driver)

"struct driver_context"?  Oh please no.

I realize that you are hopefully going to later rename this to something
else, but remember, a few patches back you thought that the "ctx" name
wasn't nice.  And here you go resuscitating it from the graveyard of
pointy bits.

And what happens if your future patch is rejected?  You are stuck with a
"driver_context" structure in a subsystem?  That's a pretty big abuse of
the global namespace, don't you think?  It sounds like something that
should go into include/linux/device.h

Please be careful about names, they mean things, even when you think
they don't.

thanks,

greg k-h
