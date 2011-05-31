Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab1EaSI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:08:56 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:33236 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab1EaSIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:08:54 -0400
Date: Tue, 31 May 2011 14:08:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [3.0-rc1] i915: blank screen on Lenovo Ideapad U160
In-Reply-To: <gi1uzevjl4.fsf@mx10.gouders.net>
Message-ID: <alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
References: <gi1uzevjl4.fsf@mx10.gouders.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Dirk Gouders wrote:

> Hello,
>
> I tested 3.0.0-rc1 on my notebook which has never been the best friend
> of the i915 driver.  With linux-2.6.38-gentoo-r4 it has the problem
> that the screen remains blank after the lid is closed and reopened, but
> that problem I can live with.  With 3.0.0-r1 I am back to a former
> problem that the screen goes (and remains) blank while booting.
>
> The next step I will do is to test linux-2.6.39-gentoo, probably I
> did not notice information that I have to adjust boot parameters or the
> kernel config?

  based on my having lived through the i915 "black screen of death",
pulling out my handy "git bisect" and with advice from chris wilson,
these days, i simply apply this patch to the source:

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index d2c7104..a1a5d03 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -152,6 +152,8 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 	struct opregion_asle *asle = dev_priv->opregion.asle;
 	u32 max;

+return ASLE_BACKLIGHT_FAILED; // rday
+
 	if (!(bclp & ASLE_BCLP_VALID))
 		return ASLE_BACKLIGHT_FAILED;


  i tried taking it out a couple of times and immediately got the same
i915-related problem so until i hear differently, the patch stays in.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
