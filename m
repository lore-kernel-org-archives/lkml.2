Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab2FZMlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:41:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57508 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab2FZMlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:41:04 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1340706382-27297-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340706382-27297-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1340706382-27297-2-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 26 Jun 2012 20:40:42 +0800
Message-ID: <CAF+7xWmR-ogy2k+e5D0og7gUPeb7dVF0ZE61QaVDeQV=6y+PcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: core: Check that the selector from
 map_voltage() is valid
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> Lots of regulator drivers have checks in their map_voltage() functions
> to verify that the result of the mapping is in the range originally
> specified. Factor these out in the core and provide a bit of extra
> defensiveness for other drivers by doing the check in the core.
>
> Since we're now doing a list_voltage() earlier move the current mapping
> back to a voltage out into the set_voltage() call to save redoing it.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Hi Mark,
This patch does not apply to both linux-next tree and regulator tree
(for-next branch).

I got below diff in drivers/regulator/core.c.rej.

--- drivers/regulator/core.c
+++ drivers/regulator/core.c
@@ -2119,10 +2128,8 @@
 		}

 		if (ret >= 0) {
-			if (min_uV < rdev->desc->ops->list_voltage(rdev,
-								   ret) &&
-			    max_uV > rdev->desc->ops->list_voltage(rdev,
-								   ret)) {
+			best_val = rdev->desc->ops->list_voltage(rdev, ret);
+			if (min_uV <= best_val && max_uV >= best_val) {
 				selector = ret;
 				ret = rdev->desc->ops->set_voltage_sel(rdev,
 								       ret);

Regards,
Axel
