Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab2I1X3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:29:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:13559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876Ab2I1X3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:29:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,504,1344236400"; 
   d="scan'208";a="228357587"
Date: Sat, 29 Sep 2012 01:28:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH v2 1/4] mfd: 88pm860x: use irqdomain
Message-ID: <20120928232858.GT30928@sortiz-mobl>
References: <1348222014-15927-1-git-send-email-haojian.zhuang@gmail.com>
 <1348222014-15927-2-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348222014-15927-2-git-send-email-haojian.zhuang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian:

On Fri, Sep 21, 2012 at 06:06:51PM +0800, Haojian Zhuang wrote:
> @@ -593,13 +610,9 @@ static int __devinit device_irq_init(struct pm860x_chip *chip,
>  				: chip->companion;
>  	unsigned char status_buf[INT_STATUS_NUM];
>  	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
> -	int i, data, mask, ret = -EINVAL;
That one breaks the build:

drivers/mfd/88pm860x-core.c: In function ‘device_irq_init’:
drivers/mfd/88pm860x-core.c:628:7: error: ‘i’ undeclared (first use in this
function)
drivers/mfd/88pm860x-core.c:628:7: note: each undeclared identifier is
reported only once for each function it appears in
drivers/mfd/88pm860x-core.c:629:3: error: ‘__irq’ undeclared (first use in
this function)
make[2]: *** [drivers/mfd/88pm860x-core.o] Error 1

I removed this patchset until it builds...

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
