Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab2CZSsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:48:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39883 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab2CZSsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:48:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5Am-igTOwWhGRmd0PCihUaWMQPEMxWJk4YuezafMJStjA@mail.gmail.com>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
	<1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
	<CAOMZO5DL8YQT2qb=vxdQtdN+zfZLK9H9_1qu5sS+1YAvSo5SAA@mail.gmail.com>
	<20120326181912.GV3852@pengutronix.de>
	<CAOMZO5Bw4fFOYSDyiE8o9AnnrzTOukJtA1JFbNBeMMzx-jBVvA@mail.gmail.com>
	<CAOMZO5Am-igTOwWhGRmd0PCihUaWMQPEMxWJk4YuezafMJStjA@mail.gmail.com>
Date: Mon, 26 Mar 2012 15:48:07 -0300
Message-ID: <CAOMZO5AW8EHBcs+YZk9wpaTBCDHe8ZErUDdJoPQAofHCivQxGw@mail.gmail.com>
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

On Mon, Mar 26, 2012 at 3:38 PM, Fabio Estevam <festevam@gmail.com> wrote:

>  static struct regulator_consumer_supply dummy_supplies[] = {
> -       REGULATOR_SUPPLY("vdd33a", "smsc911x"),
> -       REGULATOR_SUPPLY("vddvario", "smsc911x"),
> +       REGULATOR_SUPPLY("vdd33a", NULL),
> +       REGULATOR_SUPPLY("vddvario", NULL),

Actually the proper fix is:

--- a/arch/arm/plat-mxc/3ds_debugboard.c
+++ b/arch/arm/plat-mxc/3ds_debugboard.c
@@ -80,7 +80,7 @@ static struct smsc911x_platform_config smsc911x_config = {

 static struct platform_device smsc_lan9217_device = {
        .name = "smsc911x",
-       .id = 0,
+       .id = -1,
        .dev = {
                .platform_data = &smsc911x_config,
        },

Will send you the patch shortly.
