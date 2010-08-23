Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0HWPbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:31:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59338 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0HWPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:31:00 -0400
X-User-Agent: K-9 Mail for Android
References: <1282575949-27826-1-git-send-email-khilman@deeprootsystems.com> <4cb3d19e-ab7a-495f-b48c-70e3ec9f3b9b@email.android.com>
In-Reply-To: <4cb3d19e-ab7a-495f-b48c-70e3ec9f3b9b@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] driver core: platform_bus: allow runtime override of dev_pm_ops
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 23 Aug 2010 09:30:00 -0600
To: Grant Likely <grant.likely@secretlab.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: Magnus Damm <magnus.damm@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <76e79aea-684a-4447-beb8-2d6a736b0950@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Grant Likely" <grant.likely@secretlab.ca> wrote:

>
>
>"Kevin Hilman" <khilman@deeprootsystems.com> wrote:
>
>>From: Kevin Hilman <khilman@ti.com>
>>
>>Currently, the platform_bus allows customization of several of the
>>busses dev_pm_ops methods by using weak symbols so that platform code
>>can override them.  The weak-symbol approach is not scalable when
>>wanting to support multiple platforms in a single kernel binary.
>>
>>Instead, provide __init methods for platform code to customize the
>>dev_pm_ops methods at runtime.
>>
>>NOTE: after these dynamic methods are merged, the weak symbols should
>>      be removed from drivers/base/platform.c.  AFAIK, this will only
>>      affect SH and sh-mobile which should be converted to use this
>>      runtime approach instead of the weak symbols.  After SH &
>>      sh-mobile are converted, the weak symobols could be removed.
>>
>>Tested on OMAP3.
>>
>>Cc: Grant Likely <grant.likely@secretlab.ca>
>>Cc: Magnus Damm <magnus.damm@gmail.com>
>>Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>>---
>> drivers/base/platform.c         |   16 ++++++++++++++++
>> include/linux/platform_device.h |    3 +++
>> 2 files changed, 19 insertions(+), 0 deletions(-)
>>
>>diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>>index c6c933f..a7d8a00 100644
>>--- a/drivers/base/platform.c
>>+++ b/drivers/base/platform.c
>>@@ -976,6 +976,22 @@ struct bus_type platform_bus_type = {
>> };
>> EXPORT_SYMBOL_GPL(platform_bus_type);
>> 
>>+const struct dev_pm_ops * __init platform_bus_get_pm_ops(void)
>>+{
>>+	struct bus_type *bus = &platform_bus_type;
>>+
>>+	return bus->pm;
>>+}
>>+
>>+int __init platform_bus_set_pm_ops(struct dev_pm_ops *pm)
>>+{
>>+	struct bus_type *bus = &platform_bus_type;
>>+
>>+	bus->pm = pm;
>>+
>>+	return 0;
>>+}
>>+

Another (minor) note, these can be more concise.  The set open function can have a void return, and bus = &platform_bus_type lines are unnecessary.

g.

>-- 
>Sent from my Android phone with K-9 Mail. Please excuse my brevity.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
