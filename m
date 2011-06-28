Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab1F1PX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:23:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab1F1PWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:22:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 2/2] pwm: Add a i.MX23/28 pwm driver
Date: Tue, 28 Jun 2011 17:22:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de> <1309255368-9775-3-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1309255368-9775-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281722.21600.arnd@arndb.de>
X-Provags-ID: V02:K0:vaoHWQRhx4GLN/ctEyI9sUeKIaGXWXXkh/Pm957gNuZ
 csC8Xa0F8pkgRbHclHn5U6VLBiz2rMOg9Xt1aBNJwCe2sctF6q
 YZWGAhoxmQYkDIWNUzHtFxTwieDT8Kl/AubpuYQKgscXigNmbF
 +OL7ufl+eRcn1MFKLzGOLFyUuemBtL2aVQKlkkbMOPBRxjPn0X
 HTimSBfJO7UC0xo4M4qDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Tuesday 28 June 2011, Sascha Hauer wrote:
> +
> +/* common register space */
> +static void __iomem *pwm_base_common;
> +#define REG_PWM_CTRL   0x0
> +#define PWM_SFTRST     (1 << 31)
> +#define PWM_CLKGATE    (1 << 30)
> +#define PWM_ENABLE(p)  (1 << (p))
> +

The driver looks pretty good overall, but the global pwm_base_common register
is rather ugly. I think this should really be passed down through resources
from  the platform device in one way or another.

	Arnd
