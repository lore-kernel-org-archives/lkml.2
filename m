Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2JHHb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 03:31:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36063 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2JHHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 03:31:22 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-e5-50728149fec2
From: Tomasz Figa <t.figa@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: chander.kashyap@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        mturquette@linaro.org, mturquette@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Exynos4: Register clocks via common clock
 framework
Date: Mon, 08 Oct 2012 09:31:16 +0200
Message-id: <1888016.dshEnlClG6@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.2 (Linux/3.6.0-gentoo; KDE/4.9.2; x86_64; ; )
In-reply-to: <CAJuYYwQCPOFMnQrA-n42hQFtK3TXQtJSjkQZmVgh_4pqnMi8iw@mail.gmail.com>
References: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
 <2552746.GKROWAIKW8@amdc1227>
 <CAJuYYwQCPOFMnQrA-n42hQFtK3TXQtJSjkQZmVgh_4pqnMi8iw@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jAV3PxqIAg2VLOCwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLmP/nPXvCTrWLuHfUGxt2sXYycHBICJhL3D12GssUk
	Ltxbz9bFyMUhJLCIUWL7qttsIAkhgRYmiZvfDEFsNgE1ic8Nj8DiIgJ6EgeffmQFaWAWOMUo
	0d61GCwhLBAsMfXFccYuRg4OFgFVieu/3EDCvAKaEs3vboCV8AuoS7zb9pQJxBYVcJbY0jQf
	LM4J1Dql5SIjxBEbGCWe7ZvKBNEsKPFj8j0WEJtZQF5i3/6prBC2lsT6nceZJjAKzkJSNgtJ
	2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfoM+kdjKsaLA4xCnAwKvHwftQr
	ChBiTSwrrsw9xCjBwawkwiuWDRTiTUmsrEotyo8vKs1JLT7EKM3BoiTO2+yREiAkkJ5Ykpqd
	mlqQWgSTZeLglGpg5Hk1NzTc3Weh5lTt/ccemy7o1G5nSNc8uGjqlO+f9urNfv/hT7YxP4+v
	S1/kvYMmMvPfL1WuVJRZVvy6+exazRd+es9TW7Tsn4XNMXK18r8omswdt2O+4ZFV2ZMv1E0W
	8DKLc2rfx7Q2IcjqnZojW8mPP7lfbTc99nXXUfRoEZk1oXyeP6+MEktxRqKhFnNRcSIAlxN2
	Uk0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 of October 2012 12:04:18 Thomas Abraham wrote:
> Hi Tomasz,
> 
> On 3 October 2012 19:40, Tomasz Figa <t.figa@samsung.com> wrote:
> > Hi Chander, Thomas,
> > 
> > I can see one more problem here.
> > 
> > Based on the fact that sdhci-s3c driver receives only the endpoint gate
> > clock (hsmmc), doesn't the following setup make the driver unable to
> > change the frequency of this clock?
> 
> The driver never changes the clock frequency of the core system clocks
> nor of the endpoint. There are internal dividers inside the sdhci
> controller which are divide to acheive required clock speed.

What is the use of sdhci_cmu_set_clock (which calls clk_set_rate) in sdhci-
s3c, then?

I think you are missing CLK_SET_RATE_PARENT flags in clocks of which rate 
can be changed by the driver.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center

