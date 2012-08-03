Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2HCQO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:14:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53041 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2HCQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:14:27 -0400
Date: Fri, 3 Aug 2012 17:14:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120803161416.GA22563@srcf.ucam.org>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:02:19AM -0500, Seth Forshee wrote:
> Some Apple hybrid graphics machines do not have the LVDS panel connected
> to the integrated GPU at boot and also do not supply a VBT. The LVDS
> connector is not registered as a result, making it impossible to support
> graphics switching.
> 
> This patch changes intel_lvds_init() to register the connector even if
> we can't find any panel modes. This makes it necessary to always check
> intel_lvds->fixed_mode before use, as it could now be NULL.

This one kind of sucks. I think adding a quirk for this situation would 
be justifiable, rather than doing it for all devices.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
