Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1EVHW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 03:22:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56403 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1EVHWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 03:22:23 -0400
Date: Sun, 22 May 2011 08:21:47 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/12] Force always inline for gcc 4.5 when optimizing
 for size
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1105220816480.12897@skynet.skynet.ie>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> some subsystems (in my kernel) had a real problem. The biggest
> offender was DRM. I fixed those up manually by removing
> inlines. With these changes (and disabling DRM debugging, which is on
> by default) I get a kernel with force inline that is a few KB smaller.
> With DRM debugging enabled it's about 50k larger (nearly
> all of it in DRM, mostly radeon). I hope the default for this
> can be changed.

Oh these look like a good plan, one of our contributors has an inline 
fetish and it got cut-n-pasted into a few places particular in radeon.

But we won't be turning DRM debugging off, its what we use to debug things 
in the field, I did get a patch recently to reduce some of its overhead

5ad3d8831f0c97257460c11ddcc1cc0466c762d4 in my drm-next branch,
drm: Create and use drm_err from Joe Perches.

Dave.
