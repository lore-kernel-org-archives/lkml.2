Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824Ab2ERX7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:59:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35239 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2ERX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:59:20 -0400
Date: Fri, 18 May 2012 16:59:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20120518235916.GA14015@kroah.com>
References: <1337154104-22036-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337154104-22036-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 04:41:44PM +0900, Chanwoo Choi wrote:
> From: Thomas Abraham <thomas.abraham@linaro.org>
> 
> Add irq domain support for max8997 interrupts. The reverse mapping method
> used is linear mapping since the sub-drivers of max8997 such as regulator
> and charger drivers can use the max8997 irq_domain to get the linux irq
> number for max8997 interrupts. All uses of irq_base in platform data and
> max8997 driver private data are removed.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 	[Fix two bug which set max8997->irq_domain and correct wrong parameter]
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Same problem as before, I apply this and it breaks the build with the
following errors:

drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_irq_work’:
drivers/extcon/extcon-max8997.c:350:36: error: ‘struct max8997_dev’ has no member named ‘irq_base’
drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_probe’:
drivers/extcon/extcon-max8997.c:452:35: error: ‘struct max8997_platform_data’ has no member named ‘irq_base’
drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_remove’:
drivers/extcon/extcon-max8997.c:514:19: error: ‘struct max8997_dev’ has no member named ‘irq_base’

Please fix.

greg k-h
