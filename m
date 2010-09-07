Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0IGIlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:41:51 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:6554
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab0IGIlq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:41:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAPOXhUx8q2MU/2dsb2JhbAAH4FWFPQSEeIgu
X-IronPort-AV: E=Sophos;i="4.56,327,1280678400"; 
   d="scan'208";a="591799160"
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <159882.19856.qm@web180315.mail.gq1.yahoo.com>
Date: Tue, 7 Sep 2010 18:41:38 +1000
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <0D5B5291-80B9-4576-8DC7-8F33CFF2A803@niasdigital.com>
References: <159882.19856.qm@web180315.mail.gq1.yahoo.com>
To: David Brownell <david-b@pacbell.net>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/09/2010, at 4:33 PM, David Brownell wrote:

> 
> 
> --- On Mon, 9/6/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
> 
> 
>> How about this approach instead?
> 
> Still don't like it, sorry.  gpio_is_valid()
> is not intended as a fine-grained call, there is
> a call which is fine grained; use that instead.
> 

I've been sitting on the sidelines but it seems like the below might
help :-)

---8K---

A recent discussion on LKML [1] highlighted some confusion regarding the
semantics of the gpio validity checks versus the gpio request mechanism.

gpio_is_valid determines whether a gpio /can/ be attached to a
controller, gpio_request determines whether that gpio currently /is/
attached to a controller.  Part of the confusion seems to come at least
in part from the overlooking of facility for dynamically added gpio
numbers.

Fix the documentation to clarify these points.

[1] http://lkml.org/lkml/2010/8/23/187

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index d96a6db..adc0db2 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -113,12 +113,13 @@ test if a number could reference a GPIO, you may use this predicate:

	int gpio_is_valid(int number);

-A number that's not valid will be rejected by calls which may request
-or free GPIOs (see below).  Other numbers may also be rejected; for
-example, a number might be valid but unused on a given board.
+This will return true for any number which may represent a valid gpio
+regardless of whether or not that identifier is currently active.  To
+determine whether an identifier is linked to a controller and therefore
+able to be used the request/free mechanism should be used (see below).

-Whether a platform supports multiple GPIO controllers is currently a
-platform-specific implementation issue.
+Whether a platform supports multiple and/or dynamically added GPIO
+controllers is currently a platform-specific implementation issue.


Using GPIOs

