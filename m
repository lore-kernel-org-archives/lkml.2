Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1IGQg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:36:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36829 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1IGQgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:36:23 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <20110905100053.GP16691@amd.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
 <1314984756-4400-7-git-send-email-ohad@wizery.com> <20110905100053.GP16691@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 7 Sep 2011 19:36:01 +0300
Message-ID: <CAK=WgbafsdQ1MCai05jPsggJ72-jRh1w3OJ4hnuHyYMQauVvKw@mail.gmail.com>
Subject: Re: [RFC 6/7] iommu/core: add fault reporting
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

On Mon, Sep 5, 2011 at 1:00 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> Please add a seperate function for setting the fault-handler. It is
> optional, so no need to be a value of the alloc-function.

Will do.

> Can you elaborate a bit on what the user of the api will do different
> between IOMMU_TLBMISS and IOMMU_NOPTE?
> My feeling is that those differences should be handled internally in the
> IOMMU driver, but probably I miss a use-case.

I actually agree. Moreover, since we're not planning on implementing
this (dynamic PTE/TLB loading is supported by the hardware, but we're
not really using it ATM), and I don't see any other user doing so at
this point, I'll just remove those two fault types altogether.

> Also, we need some flags to distinguish between the type of the fault
> (read, write, ...).

I'll add it (though it won't be used by OMAP since the hardware
doesn't tell us this info).

Thanks!
Ohad.
