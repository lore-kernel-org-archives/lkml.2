Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2KPPa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:30:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60710 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2KPPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <20121116135625.GA18920@arwen.pp.htv.fi>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353074360-1903-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121116135625.GA18920@arwen.pp.htv.fi>
Date: Fri, 16 Nov 2012 17:30:21 +0200
Message-ID: <CAHp75VcfF9pHCa9wv_2Qr_U1y+ubJEkRvpyiXOZL_7nbPHo8uw@mail.gmail.com>
Subject: Re: [PATCH 3/6] dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 3:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Nov 16, 2012 at 03:59:16PM +0200, Andy Shevchenko wrote:
>> dma_transfer_direction is a normal enum. It means we can't usually use the
>> values as bit fields. Let's adjust this check and move it above the usage of
>> the direction parameter.
>
> why above the direction parameter ? You need to explain why ? Is it just
> because 'it looks nicer' or have you found another bug triggered by
> that ?

Many of current users do something like this:

if (dir == MEM_TO_DEV)
 { ... }
*else*
 { ... }

that potentially could trigger the bug.

-- 
With Best Regards,
Andy Shevchenko
