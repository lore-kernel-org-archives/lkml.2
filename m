Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2CLThq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:37:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64509 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2CLTho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:37:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-+L9gVBOp4RVe2pTUbBnrb-PEn7ERbWWkb=7A=4qOrdTQ@mail.gmail.com>
References: <1331197863-25564-1-git-send-email-bryan.wu@canonical.com>
	<1331197863-25564-2-git-send-email-bryan.wu@canonical.com>
	<20120308092913.GF14173@pengutronix.de>
	<CAK5ve-+L9gVBOp4RVe2pTUbBnrb-PEn7ERbWWkb=7A=4qOrdTQ@mail.gmail.com>
Date: Mon, 12 Mar 2012 20:37:44 +0100
Message-ID: <CACRpkdYvfzrdAC1vjT5WD4rk0ozpbXkPtkQpBVMv_WYhdkg7ag@mail.gmail.com>
Subject: Re: [PATCH 2/3] led-triggers: use atomic kzalloc during led trigger registering
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>
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

2012/3/10 Bryan Wu <bryan.wu@canonical.com>:
> 2012/3/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> On Thu, Mar 08, 2012 at 05:11:02PM +0800, Bryan Wu wrote:
>>> kzalloc might cause sleep and will generate some warning detected by lockdep,
>>> when call led_trigger_register_simple on each cpu cores in SMP. This patch fix
>>> this.
>> The obvious (and IMHO better) alternative is to call
>> led_trigger_register_simple from non-atomic context.
>>
>> For registering this should be OK, shouldn't it?
>>
> Thanks Uwe, it's my bad. I think I should not use on_each_cpu() API to
> run led_trigger_register_simple. on_each_cpu() will disable interrupt.

It might have been my mistake even so not your fault ... :-)

Thanks,
Linus Walleij
