Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2HEVSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:18:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36506 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab2HEVSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:18:44 -0400
Date: Sun, 5 Aug 2012 22:18:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120805211838.GA27188@srcf.ucam.org>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
 <20120803162451.GF8165@thinkpad-t410>
 <20120803162702.GA22896@srcf.ucam.org>
 <20120804165727.GA4980@thinkpad-t410>
 <20120805211412.GG12232@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120805211412.GG12232@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 11:14:12PM +0200, Daniel Vetter wrote:

> I like this approach more - the only other solution I see is to ask the
> currently active driver (i.e. radeon) at bootime for the right mode. Which
> sounds much more hellish and fragile ...

The "correct" approach is clearly to just have the drm core change the 
i2c mux before requesting edid, but that's made difficult because of the 
absence of ordering guarantees in initialisation. I don't like quirking 
this, since we're then back to the situation of potentially having to 
add every new piece of related hardware to the quirk list.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
