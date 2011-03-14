Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1CNJGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:06:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48439 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1CNJGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:06:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6284"; a="79771190"
Message-ID: <4D7DDA9C.9020700@codeaurora.org>
Date: Mon, 14 Mar 2011 02:06:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 10/10] ARM: Use struct syscore_ops instead of sysdevs
 for PM in timer and leds
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103131402.48129.rjw@sisk.pl> <201103131404.33311.rjw@sisk.pl>
In-Reply-To: <201103131404.33311.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2011 6:04 AM, Rafael J. Wysocki wrote:
>   #if defined(CONFIG_PM)&&  !defined(CONFIG_GENERIC_CLOCKEVENTS)
> -static int timer_suspend(struct sys_device *dev, pm_message_t state)
> +static int timer_suspend(void)
>   {
> -	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
> -
> -	if (timer->suspend != NULL)
> +	if (system_timer->suspend)
>   		timer->suspend();
>

Shouldn't this be system_timer->suspend() ?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

