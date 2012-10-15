Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2JOD3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 23:29:19 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62294 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2JOD3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 23:29:18 -0400
MIME-Version: 1.0
In-Reply-To: <1350053897.10584.172.camel@smile>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
	<1350053897.10584.172.camel@smile>
Date: Mon, 15 Oct 2012 08:59:17 +0530
Message-ID: <CAKohpo=20mwje+9AVgs7b-_DshyRO2DZ=Nacjm7vFAhed=Wkqg@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 20:28, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>> +     if (last_dw) {
>> +             if ((last_bus_id == param) && (last_dw == dw))
>> +                     return false;
>> +     }
> Just came to my mind.
> dw can't be NULL, can't it?
> Then
> if (last_dw) {
> ...
> }
> is unneeded.

Fixup for this:

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d72c26f..764c159 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1196,11 +1196,8 @@ bool dw_dma_generic_filter(struct dma_chan
*chan, void *param)
         * failure. If dw and param are same, i.e. trying on same dw with
         * different channel, return false.
         */
-       if (last_dw) {
-               if ((last_bus_id == param) && (last_dw == dw))
-                       return false;
-       }
-
+       if ((last_dw == dw) && (last_bus_id == param))
+               return false;
        /*
         * Return true:
         * - If dw_dma's platform data is not filled with slave info, then all
