Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2JKQ3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:29:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60369 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2JKQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:28:59 -0400
Date: Thu, 11 Oct 2012 09:28:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-input@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 7/7] Onkey: DA9055 Onkey driver
Message-ID: <20121011162852.GB15588@core.coreip.homeip.net>
References: <1349952316.9228.7.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349952316.9228.7.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Thu, Oct 11, 2012 at 04:15:16PM +0530, Ashish Jangam wrote:
> This is the ONKEY driver of the Dialog DA9055 PMIC and depends on the DA9055 MFD
> core driver.
> 
> This patch is functionally tested on SMDK6410 board.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> changes since v3:
> - used of module_platform_driver macro
> - add regmap virtual irq function
> changes since v2:
> - add support for button release
> - use of devm_request_threaded_irq API

This API does not make any sense for your driver as you are scheduling
delayed work from the IRQ handler. In such cases you need _first_ free
IRQ and _then_ cancel the work but with devm_* you do it in opposite
order.

Also, I think I mentioned this before - this driver looks like twin
brother for da9055_onkey.c. How many of such parts do you have (or will
you have)? Is there way to unify them?

Thanks.

-- 
Dmitry
