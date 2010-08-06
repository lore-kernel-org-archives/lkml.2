Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236Ab0HFLSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:18:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41727 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759228Ab0HFLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:18:41 -0400
Date: Fri, 6 Aug 2010 12:18:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH] regulator: max1586 - fix a memory leak in
 max1586_pmic_remove()
Message-ID: <20100806111839.GF398@rakim.wolfsonmicro.main>
References: <1281072795.24426.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281072795.24426.3.camel@mola>
X-Cookie: "Pok pok pok, P'kok!"
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:33:15PM +0800, Axel Lin wrote:
> In max1586_pmic_probe(), we allocate memory for max1586.
> In max1586_pmic_remove(), current implementation only free rdev
> which is a member of struct max1586_data.
> Thus, there is a small memory leak when we unload the module.
> 
> This patch fixes the memory leak by passing max1586 to i2c clientdata,
> and properly kfree(max1586) in max1586_pmic_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
