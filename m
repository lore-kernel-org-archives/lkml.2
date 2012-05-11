Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab2EKPdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:33:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44485 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853Ab2EKPdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120511141010.GE3960@opensource.wolfsonmicro.com>
References: <1336733724.5950.3.camel@sw-eng-lt-dc-vm2>
	<20120511122719.GA3960@opensource.wolfsonmicro.com>
	<CAEqHmAtm4-TkdmLSc-HUPMo_Fyw4WK+d6Xj=X9z1m4kK1A0oJw@mail.gmail.com>
	<20120511141010.GE3960@opensource.wolfsonmicro.com>
Date: Fri, 11 May 2012 16:33:45 +0100
Message-ID: <CAEqHmAtD+LUwjxAi23vv1iwrs7pQLPE6SNsAS2OPa6=9HNdYCA@mail.gmail.com>
Subject: Re: [PATCH] regmap: Add support for register paging
From: dd diasemi <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>,
        gg@slimlogic.co.uk, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 3:10 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, May 11, 2012 at 03:55:54PM +0200, dd diasemi wrote:
>> I have more advanced solution, which actually makes register mapping
>> split into virtual address ranges. This may solve many problems,
>> including giving capability to support several indirect register
>> ranges at once.
>> Let me know, what you think about this API?
>
> I think that sounds roughly like what I was thinking of so it's probably
> sensible but obviously it'll depend on the implementation.
I will use current work and add traversing of regmap_range table to
get proper range definition, then use it to do the indirect access,
like paging. Most of the drivers probably will just have one
regmap_range defined for paging or indirect registers to be accessed.
If an accessed register is not matched by any range from the table, it
will be accessed directly (without any paging).

If this is better alternative, I can continue with it. In other case,
I may send you the cleaned-up patch of current solution.

Best Regards,
Krystian
