Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0JRPJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:09:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39479 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388Ab0JRPJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:09:08 -0400
X-Sasl-enc: NOD9efgN1ewFJvW2XJgDaxgIaPZnf0K+vJcczmw7keDZ 1287414546
Message-ID: <4CBC635C.6030500@ladisch.de>
Date: Mon, 18 Oct 2010 17:10:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] char: hpet: fix information leak to userland
References: <1287326477-7940-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1287326477-7940-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov wrote:
> Structure info is copied to userland with some padding fields unitialized.
> It leads to leaking of stack memory.

> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -581,6 +581,7 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg,
>  		break;
>  	case HPET_INFO:
>  		{
> +			memset(info, 0, sizeof(*info));
>  			if (devp->hd_ireqfreq)
>  				info->hi_ireqfreq =
>  					hpet_time_div(hpetp, devp->hd_ireqfreq);

This makes the following assignment "info->hi_ireqfreq = 0;" superfluous.


Regards,
Clemens
