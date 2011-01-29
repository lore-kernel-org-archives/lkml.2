Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1A2Uwm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 15:52:42 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:54600 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477Ab1A2Uwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 15:52:41 -0500
Message-ID: <4D447E5E.6060007@metafoo.de>
Date: Sat, 29 Jan 2011 21:53:50 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Hemanth V <hemanthv@ti.com>, Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Arun Murthy <arun.murthy@stericsson.com>,
        Bill Gatliff <bgat@billgatliff.com>
Subject: Re: [RFC] add pwmlib support
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 01:21 PM, Sascha Hauer wrote:
> Hi all,
> 
> While implementing just another pwm driver I thought it's time to implement
> generic pwm support. The following series adds drivers/pwm/pwmlib.c and
> a i.MX23/28 pwm driver which serves as a usage example for pwmlib. The
> code is inspired by gpiolib support and tested using the backlight pwm
> driver by Eric Miao.
> 
> Currently the pwm_request, pwm_add, pwm_remove and pwm_free operations are
> protected with a single mutex wherea the pwm_enable, pwm_disable and
> pwm_config operations are unlocked. It is assumed that the owners of the
> pwm handle the serialization of the pwm accesses. This may not be enough, so
> i'd like to discuss the locking (and type of locking) here.
> 
> I Cced the people working with PWMs in the kernel in the hope that they can
> give input on what's missing / wrong in this implementation
> 
> Sascha
> 

Hi

There have been two other proposals for a generic PWM api during the last year.
You might want to take a look at them.

https://lkml.org/lkml/2010/2/9/275
https://lkml.org/lkml/2010/9/28/107

I've added Bill Gatliff and Arun Murthy to Cc.

- Lars
