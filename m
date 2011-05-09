Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1EIPEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:04:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48625 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1EIPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:04:03 -0400
Subject: Re: [PATCH] regulator: Move VCOINCELL to be the last element of
 mc13892_regulators array
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1304609578.5296.4.camel@phoenix>
References: <1304609578.5296.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 16:03:57 +0100
Message-ID: <1304953437.3192.13.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 23:32 +0800, Axel Lin wrote:
> In include/linux/mfd/mc13892.h, we define MC13892_VCOINCELL as 23.
> Thus VCOINCELL should be defined as 23th element in mc13892_regulators array, not the first one.
> This actually fixes an off-by-one bug while accessing mc13892_regulators array.
> 
> For example,
> In mc13892_regulator_probe, we use MC13892_VCAM as array index of mc13892_regulators array.
>         mc13892_regulators[MC13892_VCAM].desc.ops->set_mode
>                 = mc13892_vcam_set_mode;
> Currently, it access mc13892_regulators[12] ,which is VAUDIO not VCAM.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I don't have this hardware handy, just found this bug while reading the code.
> I appreciate if someone can test it.
> 
> Axel

Applied, Btw is this fix also for 2.6.39 ?

Thanks

Liam

