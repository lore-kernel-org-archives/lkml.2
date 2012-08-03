Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2HCQZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:25:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43430 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2HCQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:24:59 -0400
Date: Fri, 3 Aug 2012 11:24:51 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120803162451.GF8165@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	dri-devel@lists.freedesktop.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
	Andreas Heider <andreas@meetr.de>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803161416.GA22563@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 05:14:16PM +0100, Matthew Garrett wrote:
> On Fri, Aug 03, 2012 at 11:02:19AM -0500, Seth Forshee wrote:
> > Some Apple hybrid graphics machines do not have the LVDS panel connected
> > to the integrated GPU at boot and also do not supply a VBT. The LVDS
> > connector is not registered as a result, making it impossible to support
> > graphics switching.
> > 
> > This patch changes intel_lvds_init() to register the connector even if
> > we can't find any panel modes. This makes it necessary to always check
> > intel_lvds->fixed_mode before use, as it could now be NULL.
> 
> This one kind of sucks. I think adding a quirk for this situation would 
> be justifiable, rather than doing it for all devices.

This is one of the things I wasn't so sure about. There are various
checks in intel_lvds_init() that can cause it to bail out before we try
to get the EDID, and I don't fully understand all of them. If non-laptop
machines are expected to bail out before the EDID check then the
approach I've taken seems reasonable. Otherwise adding a quirk probably
is a good idea.

Seth

