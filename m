Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863Ab2FVBGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 21:06:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32945 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2FVBF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 21:05:28 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "G.Shark Jeong" <gshark.jeong@gmail.com>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
CC: Rob Landley <rob@landley.net>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 1/1 v4] leds: Add LED driver for lm3556 chip
Thread-Topic: [PATCH 1/1 v4] leds: Add LED driver for lm3556 chip
Thread-Index: AQHNUAwqAe2hOe5OKk2djqClUijct5cFftGQ
Date: Fri, 22 Jun 2012 01:05:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FC1C3@DQHE02.ent.ti.com>
References: <1340323926-6826-1-git-send-email-gshark.jeong@gmail.com>
 <1340323926-6826-2-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1340323926-6826-2-git-send-email-gshark.jeong@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> LM3556 :
> The LM3556 is a 4 MHz fixed-frequency synchronous boost
> converter plus 1.5A constant current driver for a high-current white
> LED.

Overall, it looks pretty good to me, especially core functionality of lm3556 is well supported and it's easy to use.

Just one thing to be better,
I would suggest to use module_i2c_driver() rather than lm3556_init/lm3556_exit for code simplicity.

> +static int __init lm3556_init(void)
> +{
> +	return i2c_add_driver(&lm3556_i2c_driver);
> +}
> +
> +static void __exit lm3556_exit(void)
> +{
> +	i2c_del_driver(&lm3556_i2c_driver);
> +}
> +
> +module_init(lm3556_init);
> +module_exit(lm3556_exit);

module_i2c_driver(lm3556_i2c_driver);

Thanks,
Milo -
