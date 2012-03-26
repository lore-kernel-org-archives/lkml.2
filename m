Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab2CZSJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:09:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51902 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab2CZSJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:09:36 -0400
MIME-Version: 1.0
In-Reply-To: <1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
	<1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
Date: Mon, 26 Mar 2012 15:09:34 -0300
Message-ID: <CAOMZO5DL8YQT2qb=vxdQtdN+zfZLK9H9_1qu5sS+1YAvSo5SAA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM i.MX 3ds debugboard: register a dummy regulator
 for the smsc911x device
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Estevam Fabio-R49496 <r49496@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Sat, Mar 3, 2012 at 8:40 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

...
>        /* Register Lan device on the debugboard */
> +       regulator_register_fixed(0, dummy_supplies, ARRAY_SIZE(dummy_supplies));

I am using linux-next, which has this patch applied and I am getting:

smsc911x smsc911x.0: Failed to get supply 'vdd33a': -517
smsc911x smsc911x.0: (unregistered net_device): couldn't get regulators -517
platform smsc911x.0: Driver smsc911x requests probe deferral

Does this work for you on pcm037?

If I select CONFIG_REGULATOR_DUMMY then the the smsc driver is probed
correctly, but if I understand correctly your suggestion was to not
select CONFIG_REGULATOR_DUMMY, right?
