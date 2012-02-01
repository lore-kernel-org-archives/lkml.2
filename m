Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2BAU2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:28:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43740 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2BAU2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <4F296721.5040203@stericsson.com>
References: <1328112555-32459-1-git-send-email-linus.walleij@stericsson.com>
	<4F296721.5040203@stericsson.com>
Date: Wed, 1 Feb 2012 21:28:43 +0100
Message-ID: <CACRpkdZ_YDoxDWx4oG62=NPeaPZanUU159PCaQy5VUsSDim+ZA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mfd/ab8500: fix error path bug
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Coquelin <maxime.coquelin@stericsson.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alex MACRO <alex.macro@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 5:24 PM, Maxime Coquelin
<maxime.coquelin@stericsson.com> wrote:
> On 02/01/2012 05:09 PM, Linus WALLEIJ wrote:

>> --- a/drivers/mfd/ab8500-core.c
>> +++ b/drivers/mfd/ab8500-core.c
>> @@ -956,9 +956,10 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
>>        return ret;
>>
>>  out_freeirq:
>> -       if (ab8500->irq_base) {
>> +       if (ab8500->irq_base)
>>                free_irq(ab8500->irq, ab8500);
>>  out_removeirq:
>> +       if (ab8500->irq_base)
>>                ab8500_irq_remove(ab8500);
>>        }
>
> Shouldn't the above brace to be removed?

Yes of course, thanks for spotting this! Fixed it in my patch queue.

Yours,
Linus Walleij
