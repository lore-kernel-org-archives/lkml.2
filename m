Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1BNTpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:45:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39642 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1BNTpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:45:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6257"; a="74210838"
Date: Mon, 14 Feb 2011 11:45:46 -0800
From: Gregory Bean <gbean@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>,
        Lennert Buytenhek <buytenh@secretlab.ca>, rvaswani@codeaurora.org
Subject: Re: [patch] drivers: gpio: sx150x: Do not access I2C from
 mask/unmask functions
Message-ID: <20110214194546.GA10940@gbean-linux.qualcomm.com>
References: <20110214164634.510293676@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214164634.510293676@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int sx150x_irq_set_type(struct irq_data *d, unsigned int flow_type)
> @@ -350,7 +353,7 @@ static int sx150x_irq_set_type(struct ir
>  
>  	chip->irq_sense &= ~(3UL << (n * 2));
>  	chip->irq_sense |= val << (n * 2);
> -	chip->irq_set_type_pending |= BIT(n);
> +	chip->update = n;

Should this be irq_update?

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
