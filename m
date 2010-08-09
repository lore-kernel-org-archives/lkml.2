Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0HII3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:29:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49759 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0HII3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:29:14 -0400
Subject: Re: [PATCH] regulator: max1586 - fix a memory leak in
 max1586_pmic_remove()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1281072795.24426.3.camel@mola>
References: <1281072795.24426.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 09:29:09 +0100
Message-ID: <1281342549.3035.3.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 13:33 +0800, Axel Lin wrote:
> In max1586_pmic_probe(), we allocate memory for max1586.
> In max1586_pmic_remove(), current implementation only free rdev
> which is a member of struct max1586_data.
> Thus, there is a small memory leak when we unload the module.
> 
> This patch fixes the memory leak by passing max1586 to i2c clientdata,
> and properly kfree(max1586) in max1586_pmic_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/max1586.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

