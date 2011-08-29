Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1H2NWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:22:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42869 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1H2NWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:22:15 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.174.182]
In-Reply-To: <20110829130552.GA10422@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
 <20110829101550.GT1923@amd.com> <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
 <20110829122516.GB9730@amd.com> <CAK=WgbbqCL60uf9gWhLYbkJo44Sva3BwQuZk2R--ER4M+yDV2w@mail.gmail.com>
 <20110829130552.GA10422@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Aug 2011 16:21:54 +0300
Message-ID: <CAK=WgbagTUqZhPkg8OnVEvF2EB=AnpgfV5Fs0g95+o1mVU47YQ@mail.gmail.com>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 4:05 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> So in this case you can skip this whole part when CONFIG_IOMMU_API is
> disabled

Sure, we can do something like this in the driver:

#ifdef CONFIG_IOMMU_API

int do_the_iommu_thing(..)
{
   ... call the IOMMU API as needed...
}

#else

int do_the_iommu_thing(..)
{
    return 0;
}

#endif

Essentially, this means implementing the !CONFIG_IOMMU_API stubs in the driver.

Possible of course, but I think it's a bit neater to have that in one
place, where all drivers can use. Similar to !CONFIG_HWSPINLOCK,
!CONFIG_DEBUG_FS, ...

> This saves you even more .text size, no?

Not sure; I expect the code to be compiled out today when the IOMMU
API is called and CONFIG_IOMMU_API is not set.
