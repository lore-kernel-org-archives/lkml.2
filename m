Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2DTSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:25:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49021 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755712Ab2DTSZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120420144256.GA6828@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
	<20120419124204.GE3046@opensource.wolfsonmicro.com>
	<CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
	<20120419162905.GA3084@opensource.wolfsonmicro.com>
	<CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
	<20120420114602.GB3259@opensource.wolfsonmicro.com>
	<CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
	<20120420130134.GA5957@opensource.wolfsonmicro.com>
	<CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
	<20120420144256.GA6828@opensource.wolfsonmicro.com>
Date: Fri, 20 Apr 2012 23:55:22 +0530
Message-ID: <CAJe_ZhdzuHo8P5WHguKMaikht8aN4RU-j_Q9FB+xOSw=roFZ=w@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 April 2012 20:12, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>
>> > No.  You're failing to understand what dummy regulators are for.
>
>> I think I do understand what dummy regulators are for and also that
>> they are meant to go away some time in future.
>
> No, they're here to stay - people will always be bringing up new boards
> after all - but they're not supposed to be used on platforms.
>
"some time in future" means utopia.... whenever that be. The longer that is
to more important is it for dummy support to be 'complete'.

>
> In any case, as I've said it's not the fact that you've got a dummy
> supply that's an issue for most of the cases you mention - it's the fact
> that the supply is always on.
>
I am not sure anymore you read my posts :(
I am more bothered by the case where the supply is always off i.e,
physically absent.

> Even in the case where a supply might genuinely be missing (which are
> very unusual, it's more effort in silicon to cope with missing supplies)
>
It's not that unusual.  See vcc_aux at line 150 of omap_hsmmc.c

See how dummy fools the driver throughout into stuff like toggling vcc
even for platforms that don't really provide vcc_aux.
In practice, see how dummy affects (negatively because of unnecessary
toggles) the vcc too.  Not every platform with omap_hsmmc might afford
having dummy disabled (I don't know all to tell for sure).

Best Regards,
-Jassi
