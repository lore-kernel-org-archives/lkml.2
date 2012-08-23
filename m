Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab2HWS3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:29:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16439 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab2HWS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:29:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 Aug 2012 11:29:31 -0700
Message-ID: <503671EF.40101@nvidia.com>
Date: Thu, 23 Aug 2012 23:39:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] max8907: fix use of possibly NULL idata
References: <1345745958-16782-1-git-send-email-swarren@wwwdotorg.org> <5036758F.1030507@wwwdotorg.org>
In-Reply-To: <5036758F.1030507@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012 11:55 PM, Stephen Warren wrote:
> On 08/23/2012 12:19 PM, Stephen Warren wrote:
> Laxman,
>
> The TPS6586x driver avoids this NULL-dereference issue by simply not
> registering any regulators when idata is NULL. See
> drivers/mfd/tps6586x.c:tps6586x_parse_dt():
>
>>          for (i = 0, j = 0; i<  num&&  j<  count; i++) {
>>                  struct regulator_init_data *reg_idata;
>>
>>                  if (!tps6586x_matches[i].init_data)
>>                          continue;
> If I interpreted Mark Brown correctly, this isn't correct; all the
> regulators within the chip should always be registered, just without any
> user-supplied constraints. Assuming I didn't misinterpret Mark, can you
> please fix the TPS6586x driver to always register the regulators, and
> apply the fix below. Could you please check the TPS65911 driver and see
> what the status is there too? Thanks very much!

Sure, I will check it.

