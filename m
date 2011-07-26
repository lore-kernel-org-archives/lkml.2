Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1GZXRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:17:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37612 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1GZXRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <1311711119-6286-3-git-send-email-per.forlin@linaro.org>
References: <1311711119-6286-1-git-send-email-per.forlin@linaro.org>
	<1311711119-6286-3-git-send-email-per.forlin@linaro.org>
Date: Wed, 27 Jul 2011 08:17:18 +0900
Message-ID: <CAC5umygcfno0-=rA9G0OcxuVK2YK9UokfoYoy45qBT8w0+ytvg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mmc: core: add random fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/27 Per Forlin <per.forlin@linaro.org>:
> This adds support to inject data errors after a completed host transfer.
> The mmc core will return error even though the host transfer is successful.
> This simple fault injection proved to be very useful to test the
> non-blocking error handling in the mmc_blk_issue_rw_rq().
> Random faults can also test how the host driver handles pre_req()
> and post_req() in case of errors.

Looks good but I have one question.

> @@ -304,6 +307,10 @@ struct mmc_host {
>
>        struct mmc_async_req    *areq;          /* active async req */
>
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +       u8                      make_it_fail;
> +       struct fault_attr       fail_mmc_request;
> +#endif
>        unsigned long           private[0] ____cacheline_aligned;
>  };

I think make_it_fail is not needed anymore because if fail_attr is
defined per-host then you can enable it by setting probability=0
or times=0 per-host.
