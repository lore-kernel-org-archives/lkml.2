Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1ILQVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:21:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34591 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1ILQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:21:33 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <20110912160252.GE11701@amd.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com> <20110912160252.GE11701@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 12 Sep 2011 19:21:13 +0300
Message-ID: <CAK=WgbZCDsBk+dueKfAX3ewsvqEnVDN+jW_ftW+BDKnayunOwA@mail.gmail.com>
Subject: Re: [PATCH 1/3] iommu/core: add fault reporting mechanism
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 7:02 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> I still don't get the need for this. It would make sense to encode
> different types of faults, like page-faults or interrupt-faults.

Right.

> When I read the comment above it sounds more like you want to encode
> different error-levels, like recoverable and unrecoverable error.
> The exact meaning of these values need to be clarified.

Well, we currently only need to say "something bad has happened".

We don't need at this point to tell whether it's a hardware bug,
inconsistent data, missing page-table entries or whatnot, because we
don't expect the user (or the iommu core itself) to do anything about
it. Not that it's not possible though: a valid response one day would
be to fix the page-table or add a missing TLB (depending on the mode
the hardware is configured to) but this is not (yet?) implemented. So
a "general unrecoverable error" is enough at this point, but it's
certainly makes sense to allow drivers to provide additional types of
errors/faults - once they are implemented.

> Please place 'event' before iova when you keep it, and not at the end.
> Then you have 'where' and 'what' of the fault first before the details
> (iova, flags).

Will do.
