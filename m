Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1CEMGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 07:06:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43080 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751109Ab1CEMGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:06:50 -0500
Date: Sat, 5 Mar 2011 12:07:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [rtc-linux] [PATCH 2/2] MAX8997/8966 RTC Driver Initial Release
Message-ID: <20110305120713.GD30187@opensource.wolfsonmicro.com>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
 <1299224924-11230-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299224924-11230-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 04:48:44PM +0900, MyungJoo Ham wrote:

> +static void tm_to_data(struct rtc_time *tm, u8 *data)
> +{
> +	data[RTC_SEC] = bin2bcd(tm->tm_sec) & 0x7f;
> +	data[RTC_MIN] = bin2bcd(tm->tm_min) & 0x7f;
> +	data[RTC_HOUR] = bin2bcd(tm->tm_hour) & 0x3f;
> +	data[RTC_WEEKDAY] = wday_kernel_to_8997(tm->tm_wday) & 0x7f;
> +	data[RTC_MONTH] = bin2bcd(tm->tm_mon) & 0x1f;
> +	data[RTC_YEAR] = bin2bcd((tm->tm_year > 100) ? (tm->tm_year - 100) : 0)
> +			& 0x7f;
> +	data[RTC_MONTHDAY] = bin2bcd(tm->tm_mday) & 0x3f;
> +
> +	if (tm->tm_year < 100) /* Prior 2000 */
> +		pr_warn("MAX8997 RTC cannot handle the year %d. "
> +				"Assume it's 2000.\n", 1900 + tm->tm_year);

It seems like an attempt to set an unsupported year should return an
error rather than just displaying a warning (though the warning is
useful so the user can figure out what went wrong).

> +MODULE_DESCRIPTION("MAXIM 8997/8966 RTC Driver");
> +MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
> +MODULE_LICENSE("GPL");

A MODULE_ALIAS() would allow the driver to be automatically loaded when
built as a module.
