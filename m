Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2HNLAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:00:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64454 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2HNLAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:00:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120314150533.GA8757@fifo99.com>
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org>
	<20120312201421.GA3459@fifo99.com>
	<4F5F41AF.1090907@codeaurora.org>
	<20120314150533.GA8757@fifo99.com>
Date: Tue, 14 Aug 2012 13:00:42 +0200
Message-ID: <CACRpkdbNVV6keGj3mCG4D8ohY4dySEwDreRV5JPrW+Vq8tM6jw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        gregkh@linuxfoundation.org, Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 4:05 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Tue, Mar 13, 2012 at 06:16:39PM +0530, Ravi Kumar V wrote:
>>
>> There is a MSM DMA driver in arch/arm/mach-msm/ which is not in
>> dmaengine framework standards, but that driver is been used by
>> client drivers nand, eMMC and serial drivers. Now if we implement
>> the whole dma driver using dmaengine framework then nand, eMMC like
>> drivers will be failed as they are using old dma driver API's, so
>> instead of implementing new driver from scratch we are keeping the
>> old dma API's as it is and using those API's in new dmaengine
>> framework.So that we can convert clients drivers to use dma engine
>> framework.
>
> Did you investigate converting the drivers (nand, eMMC, serial) ? It
> seems like there would be a 1:1 mapping between the API's , so it might
> only be a find->replace operation.

The eMMC i.e. drivers/mmc/host/msm_sdcc.c should preferably
not be converted, instead switch the platforms over to using
drivers/mmc/host/mmci.c which is already very well enabled for
DMA engine.

Augment it with Qualcomm silicon differences as needed, I do
not think they will be major.

Yours,
Linus Walleij
