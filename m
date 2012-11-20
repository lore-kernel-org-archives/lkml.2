Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2KTJkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:40:09 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49862 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2KTJkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:40:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121120093242.GK3290@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
	<20121120093242.GK3290@n2100.arm.linux.org.uk>
Date: Tue, 20 Nov 2012 15:10:06 +0530
Message-ID: <CAKohponif3xf8ymtZ4-vv8TEj74C=9_Me5osMV4dcwSfUjPZAQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 15:02, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 20, 2012 at 01:22:17AM -0800, Dmitry Torokhov wrote:
>> We'll need to invoke clk_unprepare() via a pointer in our devm_*
>> conversion so let's uninline the pair.
>
> NAK.  This breaks non-common clock using implementations.

Hi Russell,

Dummy routines for non-common clock are still there. Sorry, couldn't get
why this will break those platforms:

+static inline int clk_prepare(struct clk *clk)
+{
+       might_sleep();
+       return 0;
+}
+
+static inline void clk_unprepare(struct clk *clk)
+{
+       might_sleep();
+}
+

--
viresh
