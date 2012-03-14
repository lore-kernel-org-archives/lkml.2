Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031230Ab2CNXnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:43:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36803 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965343Ab2CNXnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:43:14 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120314140909.GN3133@opensource.wolfsonmicro.com>
References: <1331077370.20711.2.camel@phoenix> <20120314140909.GN3133@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 15 Mar 2012 07:42:53 +0800
Message-ID: <CAF+7xWnNjJbdG2G8RBG_n5KdzCLXNe0RpJ2F99gFoP+R+AMYDA@mail.gmail.com>
Subject: Re: [PATCH RFC/RFT 1/2] regulator: Fix da9052 ldo regulator names
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Mar 07, 2012 at 07:42:50AM +0800, Axel Lin wrote:
>> The regulator name for LDOs are LDO4 ... LDO13 in current implementation.
>> The correct regulator name for LDOs should be LDO1 ... LDO10.
>
> Can you please rebase this against -next?  I was going to apply but some
> of your other fixes end up conflicting with this and the second change.

hi Mark,

These two patches can be cleanly apply to -next branch.

I found the root of the conflict is because below commits are NOT in
your topic/drivers branch.
( they are in for-next branch ).
commit 4adf9beda5 regulator: Fix mask parameter in da9052_reg_update calls
commit 7b95765 regulator: Set n_voltages for da9052 regulators
commit 93651218 regulator: da9052: Ensure the selected voltage falls
within the specified range

If you have above commits in topic/drivers branch first, the you can
cleanly apply below patches.
regulator: Fix da9052 ldo regulator names
regulator: Refactor to use one da9052_ldo_ops/da9052_dcdc_ops for all LDOs/DCDCs

I'm not sure if I should re-generate these 2 patches against
topic/drivers branch because
you will have conflict when merge them to for-next branch then.

Regards,
Axel
