Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1HWVxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:53:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43835 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWVxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:53:44 -0400
MIME-Version: 1.0
In-Reply-To: <201108232351.55432.rjw@sisk.pl>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
	<201108232351.55432.rjw@sisk.pl>
Date: Tue, 23 Aug 2011 23:53:42 +0200
X-Google-Sender-Auth: rb_UOznEBANH5nAChd1Oe6_YCH4
Message-ID: <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 23, 2011 at 11:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> and the boot runs very slowly.  Reverting the series merged in 56f0be
>> appears to resolve the issue,
>
> In fact, the patch from:
>
> https://patchwork.kernel.org/patch/1083602/
>
> is sufficient to make the calltrace go away.

Yes, that's true but the added might_sleep() discovered an actual bug
here, so I still think it's better to keep it there.

If proper fix is difficult, I think doing something like if
(!in_atomic()) try_to_freeze() with big fat warning explaining what's
broken and how it should be fixed should do it for now if the proper
fix is gonna take some time. That way, we document what's broken where
it's broken and get to keep the useful debugging annotation.

Thank you.

-- 
tejun
