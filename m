Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2LRRQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:16:14 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52842 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2LRRQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:16:13 -0500
X-Originating-IP: 108.223.40.66
Date: Tue, 18 Dec 2012 09:16:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange results of DIV_ROUND_CLOSEST
Message-ID: <20121218171620.GA19972@roeck-us.net>
References: <201212181603.42094.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212181603.42094.jbe@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:03:41PM +0100, Juergen Beisert wrote:
> Hi list,
> 
> commit 263a523d18bca306016d75f5c8d5c57c37fe52fb changes the code of 
> DIV_ROUND_CLOSEST in include/linux/kernel.h to fix a compile time warning.
> 
> But now feeding in a zero into this macro results into 4198403. Tested with 
> gcc 4.4.3 and 4.7.2, on arch x86 and ARM.
> 
> I can reproduce this behaviour, when my ADC delivers a '0' value in the driver 
> drivers/hwmon/s3c-hwmon.c in function s3c_hwmon_ch_show() with a current 
> 3.7.1 kernel. The value is correct again, when the ADC delivers at least 
> a '1'.
> 
> Any ideas how to fix it correctly?
> 
Odd one. I ran the macro through a large number of values and divisors as well
as various optimization options, with different compilers, and always get
correct results.

What are your compile options, and what are the channel multiplier and dividers
set to ?

Thanks,
Guenter
