Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1GOApQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:45:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58513 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640Ab1GOApN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:45:13 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110714234805.GA32716@opensource.wolfsonmicro.com>
References: <1310650159.6854.1.camel@phoenix> <20110714234805.GA32716@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 15 Jul 2011 08:44:53 +0800
Message-ID: <CAF+7xWnOZkOpMSiOBJKA2HMpstzqUt1GT3Gr+g783trYH+kj3A@mail.gmail.com>
Subject: Re: [PATCH] regulator: Fix memory leak in set_machine_constraints()
 error paths
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/15 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Jul 14, 2011 at 09:29:19PM +0800, Axel Lin wrote:
>>  static int set_machine_constraints(struct regulator_dev *rdev,
>>       const struct regulation_constraints *constraints)
>>  {
>> -     int ret = 0;
>> +     int ret;
>>       struct regulator_ops *ops = rdev->desc->ops;
>>
>
> This doesn't look like a leak fix?  There's nothing that checks for
> other errors here (like null pointers)?
>

I think it does checking null pointer for rdev->constraints in current
implementation:

static int set_machine_constraints(struct regulator_dev *rdev,
        const struct regulation_constraints *constraints)
{
        int ret;
        struct regulator_ops *ops = rdev->desc->ops;

        rdev->constraints = kmemdup(constraints, sizeof(*constraints),
                                    GFP_KERNEL);
        if (!rdev->constraints)
                return -ENOMEM;


Regards,
Axel
