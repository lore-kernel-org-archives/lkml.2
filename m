Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab1CDI64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:58:56 -0500
Received: from mail.perches.com ([173.55.12.10]:4113 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1CDI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:58:54 -0500
Subject: Re: [PATCH 2/2] MAX8997/8966 RTC Driver Initial Release
From: Joe Perches <joe@perches.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
In-Reply-To: <1299224924-11230-1-git-send-email-myungjoo.ham@samsung.com>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
	 <1299224924-11230-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 00:58:52 -0800
Message-ID: <1299229132.1929.53.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 16:48 +0900, MyungJoo Ham wrote:
> This patch adds support for RTC functionality for MAX8997/8966 chips.

just trivial comments here too.

> diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
[]
> +static void __maybe_unused dump(struct rtc_data *rtc)
> +{
> +	int i, j;
> +	char buf[256];
> +	char *ptr;
> +	u8 val;
> +
> +	for (i = 0; i < 3; i++) {
> +		ptr = buf;
> +		ptr += sprintf(ptr, "[%2.2xh] ", i * 16);
> +		for (j = 0; j < 16; j++) {
> +			max8997_read_reg(rtc->i2c, i * 16 + j, &val);
> +			ptr += sprintf(ptr, "%2.2x ", val);
> +		}
> +		pr_info("%s\n", buf);
> +	}
> +}

It might be better to use a loop to read all the registers
and then print_hex_dump.  Something like:

static void __maybe_unused dump(struct rtc_data *rtc)
{
	int i;
	u8 buf[48];

	for (i = 0; i < 48; i++)
		max8997_read_reg(rtc->i2c, i, &buf[i]);
	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1,
		       buf, sizeof(buf), false);
}



