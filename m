Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1IMMtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:49:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57167 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1IMMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:49:17 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <20110913104433.GL11701@amd.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
 <1315421604-12286-3-git-send-email-ohad@wizery.com> <20110913101011.GK11701@amd.com>
 <CAK=WgbbhdFpAHTt=Bku-v1ZOCf48+u+XB-f4yO=5EDojv1kCJg@mail.gmail.com> <20110913104433.GL11701@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 13 Sep 2011 15:48:54 +0300
Message-ID: <CAK=Wgbb_DZgH0jvgQr_Rt7G0-Cy0q2pHe+auBOtrFai-D-yMSQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] iommu/core: split mapping to page sizes as supported
 by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 1:44 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> Not necessarily. You could implement this side-by-side with the old code
> until all drivers are converted and remove the old code then. This keeps
> bisectability.

Ok.

>> > Intel IOMMU does not support arbitrary page-sizes, afaik.
>>
>> It does; besides the usual 4K it has "super page sizes" support of
>> 2MB, 1GB, 512GB and 1TB.
>
> But the value ~0xfffUL indicates support for 4k, 8k, 16k .. 2^63, no?

Yes, I have done this intentionally, in order to retain the existing
behavior for IOMMU drivers which are already capable of handling
arbitrary page sizes (intel-iommu handles this in software, see
hardware_largepage_caps() and the code that uses it).

Long term, it might make more sense to remove
hardware_largepage_caps() (and the logic around it) and instead just
declare the real page sizes the hardware supports when calling
register_iommu(), but I guess it's up to Intel guys. For now it's just
safer to declare ~0xfffUL which really means: keep calling me with
sizes and alignments that are an order of 4KB, just like you always
did.
