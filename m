Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2DATkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:40:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36476 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2DATkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Mon, 2 Apr 2012 01:09:27 +0530
X-Google-Sender-Auth: UDHkvuCmKDpixsmNNwS54MaRILQ
Message-ID: <CAH+eYFC+q4xFuSdRBkO9nb0XZWU4pQ_yCyinMy2X3ds9WQd1kw@mail.gmail.com>
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 00:52, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sun, Apr 1, 2012 at 8:58 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>
>> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
>> index ebc1e86..5be3248 100644
>> --- a/drivers/mfd/db8500-prcmu.c
>> +++ b/drivers/mfd/db8500-prcmu.c
>> @@ -2788,6 +2788,7 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
>>                .constraints = {
>>                        .name = "db8500-vape",
>>                        .valid_ops_mask = REGULATOR_CHANGE_STATUS,
>> +                       .always_on = true,
>>                },
>>                .consumer_supplies = db8500_vape_consumers,
>>                .num_consumer_supplies = ARRAY_SIZE(db8500_vape_consumers),
>
> Combined with the PL022 patch this causes a power regression since
> the PL022 is hereafter always on.

How can there be a "power regression" here?  This is the only user of
the vcore regulator, and, apart from the fact that its disable routine
only decrements an essentialy write-only variable, it is shared which
several devices which already never disable it.
