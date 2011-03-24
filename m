Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1CXNOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:14:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44102 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab1CXNOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:14:02 -0400
Message-ID: <384BC720F8C741B886DC000F067EBA20@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        "Stalin Srinivasan" <stalin.s@mistralsolutions.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com> <4D776B05.4010506@pengutronix.de>
In-Reply-To: <4D776B05.4010506@pengutronix.de>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Date: Thu, 24 Mar 2011 18:46:22 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> A device may be de-initialized and another loaded or two different devices
> can be run simultaneously on the two cores.
> It's also possible, as in our case, to implement a single device on both
> the PRU's resulting in improved load sharing.

>Make you driver compile with sparse "make C=1", you cast way too much
>when accessing io mem. Use void __iomem * instead of u32 *.


With make C=1 I am receiving some warnings such as:

warning: cast removes address space of expression
drivers/mfd/da8xx_pru.c:61:17: warning: incorrect type in argument 1 
(different base types)
drivers/mfd/da8xx_pru.c:61:17:    expected void const volatile [noderef] 
<asn:2>*<noident>
drivers/mfd/da8xx_pru.c:61:17:    got int
drivers/mfd/da8xx_pru.c:66:28: warning: incorrect type in argument 1 
(different address spaces)

I can remove all of these by casting to (__force void  __iomem *) but is 
this correct.

-SG 

