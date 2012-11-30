Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2K3NLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:11:13 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61774 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2K3NLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:11:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121130124518.GF26023@gmail.com>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
	<121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
	<20121130105731.GN3176@sortiz-mobl>
	<20121130124518.GF26023@gmail.com>
Date: Fri, 30 Nov 2012 18:41:11 +0530
Message-ID: <CAKohpomNFmLwf-Gs_mmXV0ULU87-FWCxVGUTfrEM-m6NNt3nPw@mail.gmail.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 November 2012 18:15, Lee Jones <lee.jones@linaro.org> wrote:
> The patch doesn't apply for me - does it for you?
>
> Viresh, what's it based on?

Because this was applied 2 days back by Samuel, and i didn't
fetch it again yesterday:

commit 20d5c7defc228cdaeff3ce3442f3a4e86af293c1
Author: Randy Dunlap <rdunlap@infradead.org>
Date:   Mon Nov 12 09:20:49 2012 -0800

    mfd: Fix stmpe.c build when OF is not enabled

    Fix build errors when CONFIG_OF is not enabled by including
    <linux/of.h> (needs to be added in any case).
    An alternative fix could be to make the driver depend on OF.

    drivers/mfd/stmpe.c:1025:2: error: implicit declaration of
function 'of_property_read_u32'
    drivers/mfd/stmpe.c:1030:2: error: implicit declaration of
function 'for_each_child_of_node'
    drivers/mfd/stmpe.c:1030:36: error: expected ';' before '{' token

    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/stmpe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 0061d1b..f9f7de7 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/of.h>


Its a simple conflict to fix, as this is the only place of conflict.

--
viresh
