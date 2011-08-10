Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1HJWda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 18:33:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41434 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1HJWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 18:33:28 -0400
Subject: Re: [PATCH] rtc: ep93xx: Fix 'rtc' may be used uninitialized
 warning
From: John Stultz <john.stultz@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
In-Reply-To: <1312981886.21916.2.camel@phoenix>
References: <1312981886.21916.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:33:15 -0700
Message-ID: <1313015595.15198.86.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 21:11 +0800, Axel Lin wrote:
> commit 92d921c5d "rtc: ep93xx: Initialize drvdata before registering device"
> ensures the drvdata is initialized prior to registering the rtc device.
> But it set the drvdata to an uninitialized pointer.
> Thus calling platform_get_drvdata in ep93xx_rtc_remove does not get correct address.
> 
> This patch fixes below warning by adding struct rtc_device *rtc to struct ep93xx_rtc.
> Then set platform drvdata to ep93xx_rtc instead of rtc.
> 
>   CC      drivers/rtc/rtc-ep93xx.o
> drivers/rtc/rtc-ep93xx.c: In function 'ep93xx_rtc_probe':
> drivers/rtc/rtc-ep93xx.c:154: warning: 'rtc' may be used uninitialized in this function
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>


Thanks! I went ahead and queued this.

-john


