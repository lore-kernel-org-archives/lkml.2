Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3ABXvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:51:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3ABXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:50:58 -0500
Date: Wed, 2 Jan 2013 15:50:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Marc Dietrich <marvin24@gmx.de>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] rtc: add RTC driver for TPS6586x
Message-Id: <20130102155057.9fb6ede2.akpm@linux-foundation.org>
In-Reply-To: <50DC6242.1000404@nvidia.com>
References: <1356102748-722-1-git-send-email-ldewangan@nvidia.com>
	<7345841.MepJzddHFh@ax5200p>
	<50DC6242.1000404@nvidia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2012 20:29:14 +0530
Laxman Dewangan <ldewangan@nvidia.com> wrote:

> On Thursday 27 December 2012 08:26 PM, Marc Dietrich wrote:
> > Hi Laxman,
> >
> > On Friday 21 December 2012 20:42:28 you wrote:
> >
> >> +
> >> +	/* Set epoch start as 00:00:00:01:01:2000 */
> >> +	rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);
> > any reason why you hard coded it to 2000? All boards I know use 2009, so with
> > this patch, everyone needs to set his clock again.
> >
> 
> No specific reason. If 2009 should be default then I can push patch to 
> set it as 2009.

I'd like to get this into Linus soon so let's get it finished.  I
assume it's merely this?

--- a/drivers/rtc/rtc-tps6586x.c~rtc-add-rtc-driver-for-tps6586x-fix2
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -260,8 +260,8 @@ static int tps6586x_rtc_probe(struct pla
 	rtc->dev = &pdev->dev;
 	rtc->irq = platform_get_irq(pdev, 0);
 
-	/* Set epoch start as 00:00:00:01:01:2000 */
-	rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);
+	/* Set epoch start as 00:00:00:01:01:2009 */
+	rtc->epoch_start = mktime(2009, 1, 1, 0, 0, 0);
 
 	/* 1 kHz tick mode, enable tick counting */
 	ret = tps6586x_update(tps_dev, RTC_CTRL,
_

