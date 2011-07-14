Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1GNK3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 06:29:32 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:21577 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200Ab1GNK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 06:29:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACnEHk5tg7bC/2dsb2JhbABTp1F4iHoCwVQOhiwEozc
Date: Thu, 14 Jul 2011 12:29:28 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org
Subject: Re: [PATCH 07/11] Watchdog: DA9052 watchdog support v1
Message-ID: <20110714102928.GL3834@infomag.iguana.be>
References: <1309872103.960.79.camel@L-0532.kpit.com> <1310630232.284.16.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310630232.284.16.camel@L-0532.kpit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish, Dajun,

> > This driver adds support for the watchdog functionality provided by the Dialog
> > Semiconductor DA9052 PMIC chip.
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> If there are no comments then can you ACK this patch?

I remain with my comment of Wed 26 Jan 2011:
> The ioctl WDIOC_SETOPTIONS call is not in line with the watchdog API.
> the supported options are:
> #define WDIOS_DISABLECARD       0x0001  /* Turn off the watchdog timer */
> #define WDIOS_ENABLECARD        0x0002  /* Turn on the watchdog timer */
> #define WDIOS_TEMPPANIC         0x0004  /* Kernel panic on temperature trip */
> Your options are:
> #define DA9052_STROBING_FILTER_ENABLE   0x0001
> #define DA9052_STROBING_FILTER_DISABLE  0x0002
> #define DA9052_SET_STROBING_MODE_MANUAL 0x0004
> #define DA9052_SET_STROBING_MODE_AUTO   0x0008
> 
> Please explain what you want to do.

FYI: this is how the code looks now:
+       case WDIOC_SETOPTIONS:
+               if (get_user(new_value, p))
+                       return -EFAULT;
+               if (new_value == DA9052_ENABLE || new_value == DA9052_DISABLE)
+                       da9052_sm_set_strobing_filter(wdt, new_value);
+               else
+                       wdt->pwdt->sm_strobe_mode_flag = new_value;
+               return 0;

Since the code is still not in line with the watchdog API and since I did not get
an answer yet on what you (or Dajun) want to do, there is definitely NO ACK yet.
If there is a good reasoning behind your needs, we might conclude that this is indeed
worthwhile and extend the API in a proper way. But as it is now, it's not correct.

Kind regards,
Wim.

