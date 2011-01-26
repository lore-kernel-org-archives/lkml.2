Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1AZVOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:14:03 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:40919 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929Ab1AZVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:14:01 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADocQE1R8GBz/2dsb2JhbACkd3S8dw2FQgQ
Date: Wed, 26 Jan 2011 22:13:59 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCHv3 7/11] WDT: Watchdog timer module of DA9052 device
	driver
Message-ID: <20110126211359.GA3790@infomag.iguana.be>
References: <AANLkTi=AvA-hOa=5vSoZLMQXsXHdWWieFmCCVx7-p+T4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=AvA-hOa=5vSoZLMQXsXHdWWieFmCCVx7-p+T4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +static long da9052_wdt_ioctl(struct file *file, unsigned int cmd,
> +				unsigned long arg)
> +{
> +	struct da9052_wdt *wdt = get_wdt_da9052();
> +	void __user *argp = (void __user *)arg;
> +	int __user *p = argp;
> +	unsigned char new_value;
> +
> +	switch (cmd) {
> +
> +	case WDIOC_GETSUPPORT:
> +		return copy_to_user(argp, &da9052_wdt_info,
> +			sizeof(da9052_wdt_info)) ? -EFAULT : 0;
> +	case WDIOC_GETSTATUS:
> +	case WDIOC_GETBOOTSTATUS:
> +		return put_user(0, p);
> +	case WDIOC_SETOPTIONS:
> +		if (get_user(new_value, p))
> +			return -EFAULT;
> +		if (new_value & DA9052_STROBING_FILTER_ENABLE)
> +			da9052_sm_set_strobing_filter(wdt, ENABLE);
> +		if (new_value & DA9052_STROBING_FILTER_DISABLE)
> +			da9052_sm_set_strobing_filter(wdt, DISABLE);
> +		if (new_value & DA9052_SET_STROBING_MODE_MANUAL)
> +			da9052_sm_set_strobing_mode(DA9052_STROBE_MANUAL);
> +		if (new_value & DA9052_SET_STROBING_MODE_AUTO)
> +			da9052_sm_set_strobing_mode(DA9052_STROBE_AUTO);
> +		return 0;

The ioctl WDIOC_SETOPTIONS call is not in line with the watchdog API.
the supported options are:
#define	WDIOS_DISABLECARD	0x0001	/* Turn off the watchdog timer */
#define	WDIOS_ENABLECARD	0x0002	/* Turn on the watchdog timer */
#define	WDIOS_TEMPPANIC		0x0004	/* Kernel panic on temperature trip */

Your options are:
#define DA9052_STROBING_FILTER_ENABLE	0x0001
#define DA9052_STROBING_FILTER_DISABLE	0x0002
#define DA9052_SET_STROBING_MODE_MANUAL	0x0004
#define DA9052_SET_STROBING_MODE_AUTO	0x0008

Please explain what you want to do.

Thanks in advance,
Wim.

