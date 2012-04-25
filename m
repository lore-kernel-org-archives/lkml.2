Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2DYDCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:02:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56373 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2DYDCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120424201802.GE3628@n2100.arm.linux.org.uk>
References: <cover.1335266056.git.viresh.kumar@st.com>
	<abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
	<20120424120019.GE24089@lunn.ch>
	<CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
	<20120424201802.GE3628@n2100.arm.linux.org.uk>
Date: Wed, 25 Apr 2012 08:32:14 +0530
Message-ID: <CAOh2x==Se4ipK_jexOE_=82=S4p41W9Ek0Om6DrUwctSz-Wcyw@mail.gmail.com>
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
From: viresh kumar <viresh.linux@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Viresh Kumar <viresh.kumar@st.com>,
        akpm@linux-foundation.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 1:48 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> Look, it's very very simple.

Thanks for explaining.

> Finally, if a platform has clk API support enabled, and a driver requests
> a clock, and clk_get() returns an error, it means the clock was not found.
> That's a fatal error for the driver, because it means that something is
> wrong in the lookup tables - moreover, it means that _potentially_ someone
> screwed up the clk matching and this device has a clock which needs some
> control, but wasn't found.  I don't think ignoring that kind of error,
> even by printing a warning, is a particularly good approach - it seems
> to me it makes things fragile.  What if this missing clock causes the
> bus to your device to ultimately hang?

This is what i was thinking too and thats why floated this version of patch.
But as Andrew said, clk API support is enabled for them, but still they
don't have a clk for sata. To get this working, there are two solutions:
- Create dummy clk for sata for that platform, so clk_get doesn't fail.
- Check for error before every call to clk APIs after clk_get().

Andrew favored the second one. Which means, even on platforms
with clk API defined and clk enable required, if there are some issues
with lookup table, and clk_get() fails, system may hang when registers
are accessed. For this i favored first one.

--
viresh
