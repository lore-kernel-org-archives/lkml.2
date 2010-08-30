Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0H3NZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:25:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0H3NZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:25:43 -0400
Date: Mon, 30 Aug 2010 15:25:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 1/4] Adding documention
In-Reply-To: <4C7ABA64.50005@seas.upenn.edu>
Message-ID: <alpine.LNX.2.00.1008301525240.1019@pobox.suse.cz>
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu> <1282798497-19791-2-git-send-email-rafi@seas.upenn.edu> <4C77AA45.4030805@euromail.se> <4C7ABA64.50005@seas.upenn.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Aug 2010, Rafi Rubin wrote:

> >> +----------
> >> +
> >> +Note: values set at load time are global and will apply to all applicable
> >> +devices.  Adjusting parameters with sysfs will override the load time values,
> >> +but only for that one device.
> >> +
> >> +The following parameters are used to configure filters to reduce noise:
> >> +
> >> +activate_slack		number of fingers to ignore before processing events
> >> +
> >> +activation_height	size threshold to activate immediately
> >> +activation_width
> >> +
> >> +min_height		size threshold bellow which fingers are ignored
> >> +min_width		both to decide activation and during activity
> >> +
> >> +deactivate_slack	the number of "no contact" frames to ignore before
> >> +			propagating the end of activity events
> >> +
> >> +When the last finger is removed from the device, it sends a number of empty
> >> +frames.  By holding off on deactivation for a few frames we can tolerate false
> >> +erroneous disconnects, where the sensor may mistakenly not detect a finger that
> >> +is still present.  Thus deactivate_slack addresses problems where a users might
> >> +see breaks in lines during drawing, or drop an object during a long drag.
> > 
> > 
> > Without contact tracking, it is hard to imagine activation filtering to work
> > properly. I would advocate to remove this functionality from the driver, and add
> > it in userspace instead.
> > 
> > Henrik
> 
> I don't think its quite time to remove these filters.  There still isn't a
> proper replacement that's readily accessible to most users.  From what I've
> heard many still use the wacom driver to support touch in X.
> 
> Tracking only helps if you increase the activation slack to more than 1 contact
> (the current default), and only if you assume the you will see ghosts span
> multiple frames in two different locations, which may be even less likely than
> seeing a ghost in one spot for two frames.
> 
> Maybe in a few more months or another year, it will make more sense to remove
> the filters from this driver.  In the mean time, is it really preferable to
> leave them undocumented?

Agreed. I have now applied the patch, thanks Rafi.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
