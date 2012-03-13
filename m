Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab2CMIvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:51:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab2CMIvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYvfzrdAC1vjT5WD4rk0ozpbXkPtkQpBVMv_WYhdkg7ag@mail.gmail.com>
References: <1331197863-25564-1-git-send-email-bryan.wu@canonical.com>
 <1331197863-25564-2-git-send-email-bryan.wu@canonical.com>
 <20120308092913.GF14173@pengutronix.de> <CAK5ve-+L9gVBOp4RVe2pTUbBnrb-PEn7ERbWWkb=7A=4qOrdTQ@mail.gmail.com>
 <CACRpkdYvfzrdAC1vjT5WD4rk0ozpbXkPtkQpBVMv_WYhdkg7ag@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 13 Mar 2012 16:50:51 +0800
X-Google-Sender-Auth: RgFO_FmYmMqd95UPdQmvtDEL6ko
Message-ID: <CAK5ve-+ZNoiS3qdQ6O543uSAO9L0rr2c=WwuXm-biAqfGfjc7w@mail.gmail.com>
Subject: Re: [PATCH 2/3] led-triggers: use atomic kzalloc during led trigger registering
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ming Lei <ming.lei@canonical.com>, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 3:37 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2012/3/10 Bryan Wu <bryan.wu@canonical.com>:
>> 2012/3/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>>> On Thu, Mar 08, 2012 at 05:11:02PM +0800, Bryan Wu wrote:
>>>> kzalloc might cause sleep and will generate some warning detected by lockdep,
>>>> when call led_trigger_register_simple on each cpu cores in SMP. This patch fix
>>>> this.
>>> The obvious (and IMHO better) alternative is to call
>>> led_trigger_register_simple from non-atomic context.
>>>
>>> For registering this should be OK, shouldn't it?
>>>
>> Thanks Uwe, it's my bad. I think I should not use on_each_cpu() API to
>> run led_trigger_register_simple. on_each_cpu() will disable interrupt.
>
> It might have been my mistake even so not your fault ... :-)
>

No problem, man. I just simply replaced GFP_KERNEL with GFP_ATOMIC
without thinking deeper.

Best Regards,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
