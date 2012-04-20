Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2DTKbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:31:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59304 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2DTKbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:31:14 -0400
Date: Fri, 20 Apr 2012 11:31:10 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
Message-ID: <20120420103110.GD3467@shadowen.org>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
 <CAPM=9tzC5M-K-irN=Dw3Ai+2ExUj_vSCVYUj-qpmccHLAeaifA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzC5M-K-irN=Dw3Ai+2ExUj_vSCVYUj-qpmccHLAeaifA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 10:40:35AM +0100, Dave Airlie wrote:

> I've just revisited this, maybe I'm going insane but why does
> drm_global_mutex not stop this?
> 
> drm_get_pci_dev takes drm_global_mutex before calling drm_fill_in_dev
> and drm_get_minor.
> 
> Now the fops should be pointing at stub_open at this point, as we
> won't have switched to the per device fops yet,
> and one of the first things drm_stub_open does is take the
> drm_global_mutex before doing the idr lookup.
> 
> So is the problem opening some sysfs or proc file early?

I may be reading things wrong but the initialisation does indeed hold
drm_global_mutex, but and back when this first occured we would have
been using kernel_lock() which was at least partially reentrant right?

Anyhow, I will go back to the reporter and try and get a proper
reproduce by, there is no point in fixing something which is something
else.

-apw
