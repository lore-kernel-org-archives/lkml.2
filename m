Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1I0N3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:29:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59660 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1I0N27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:28:59 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.46.211]
In-Reply-To: <20110927131222.GL2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com> <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com> <20110927131222.GL2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Sep 2011 16:28:37 +0300
Message-ID: <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 4:12 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> You pass a pointer to an unsigned long for the page-size bitmap. This
> allows to use an array of unsigned long. But a single unsigned long is
> sufficient

This is fine; I can change that if you like it better (though without
doing the change below this is probably moot).

> and you can use functions like ffs() and fls() together with
> shifting. These functions often translate to a single intruction in the
> binary. The find_next_bit function has much more overhead because it
> needs to handle the array-of-ulong case.

So you're suggesting to re-implement find_next_bit() using ffs()/fls()
and shifting ?

What's the point ?

Sure, if we'll have a proven performance issue while using
find_next_bit() we can think of doing this, but at this stage, this
sounds to me like a premature optimization which isn't too elegant.

At this point I strongly prefer readable, maintainable and easier to
debug code over optimization which isn't proven to be necessary.

Thanks,
Ohad.
