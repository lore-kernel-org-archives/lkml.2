Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422729Ab2JLKg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:36:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61999 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422717Ab2JLKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:36:58 -0400
MIME-Version: 1.0
In-Reply-To: <1350030203.10584.139.camel@smile>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
	<1350030203.10584.139.camel@smile>
Date: Fri, 12 Oct 2012 16:06:56 +0530
X-Google-Sender-Auth: -mTNF55uILBS39lTb1sDM7zGYOU
Message-ID: <CAOh2x=m8OVNfMm5Fn+cr9Gxuh6oyt+8d4n-bkG8Xiw5zGncLiA@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 1:53 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Fri, 2012-10-12 at 11:14 +0530, Viresh Kumar wrote:

>> +     while (++i < dw->sd_count) {
>> +             if (!strcmp(dw->sd[i].bus_id, param)) {
>> +                     found = 1;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (!found) {
>> +             last_dw = dw;
>> +             last_bus_id = param;
>> +             return false;
> Because of return here you could eliminate 'found' flag at all.

how?

Fixed the other issue as:

Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Oct 12 16:06:32 2012 +0530

    fixup! dmaengine: dw_dmac: Enhance device tree support
---
 drivers/dma/dw_dmac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9a7d084..a4ff04c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1598,9 +1598,10 @@ __devinit dw_dma_parse_dt(struct platform_device *pdev)
        return pdata;
 }
 #else
-static inline int dw_dma_parse_dt(struct platform_device *pdev)
+static inline struct dw_dma_platform_data *
+dw_dma_parse_dt(struct platform_device *pdev)
 {
-       return -ENOSYS;
+       return NULL;
 }
 #endif

--
viresh
