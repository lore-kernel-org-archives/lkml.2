Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1ALQjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:39:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:44477 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1ALQjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:39:18 -0500
Date: Wed, 12 Jan 2011 16:39:07 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for rc1
In-Reply-To: <AANLkTik32TC_eMbe0rZ+g11hFy9Z2_yY38avzY0GbgPv@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101121608560.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <alpine.LFD.2.00.1101121235360.8212@casper.infradead.org>
 <4D2DA6A7.4010609@de.ibm.com> <alpine.LFD.2.00.1101121324550.8212@casper.infradead.org> <AANLkTik32TC_eMbe0rZ+g11hFy9Z2_yY38avzY0GbgPv@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> IOW, I'm inclined to just do the revert. The "fix" clearly breaks
> things, and now you're adding random parts of the function back rather
> than just calling the "fill_fix()" function like things used to. Why?

Its not the final patch. I'm trying to get feedback on what broke exactly.

> The commit message in dfe63bb0ad98 doesn't support any of these hacks
> - it just seems to say that drm_fb_helper_fill_fix() should also have
> been called from setcolreg().
>
> So why don't we just revert the commit and instead add that
> drm_fb_helper_fill_fix() to setcolreg()?

Fine by me. The real problem is the nouveau driver is using the 
framebuffer device (fb_fillrect) before set_par is ever called.
Before calling set_par the framebuffer state is not defined.
