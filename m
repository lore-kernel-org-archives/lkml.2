Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2DTHcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:32:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34408 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2DTHcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120419162905.GA3084@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
	<20120419124204.GE3046@opensource.wolfsonmicro.com>
	<CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
	<20120419162905.GA3084@opensource.wolfsonmicro.com>
Date: Fri, 20 Apr 2012 13:02:06 +0530
Message-ID: <CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 April 2012 21:59, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Apr 19, 2012 at 07:35:03PM +0530, Jassi Brar wrote:
>
>> Another POV is :
>>   Is a consumer's need, to know if the gotten regulator is a real
>> or a dummy one, reasonable ?
>
> Absolutely not, you're completely failing to understand what I said
> about abstraction here.  *Nothing* about this is anything to do with
> dummy regulators in the slightest, it's about supplies which are already
> on at the time the driver powers the device up.  Doing this for dummy
> regulators is not helpful, being enabled isn't in the slightest bit tied
> to the fact that the regulator is a dummy regulator and it's silly to
> optimise this only in the specific case where a dummy regulator (which
> is in the first place only a crutch to keep systems with buggy regulator
> setups going) is being used is silly.
>
> I'd suggest checking with regulator_is_enabled() prior to power up, or
> adding a notifier for physical enable events and using that.
>
Sorry for being slow.
How would you suggest one works out the following arrangement ?

Say, an audio CODEC chip has a simple PLL1 run by main voltage
domain(Vmain). PLL1 can only support 11025x sample rates.
Another PLL2 on the chip, powered by optional supply Vaux, could
provide 8000x sample rates. Obviously low-end platforms could choose
to not provide Vaux.

The platform has some other drivers that need to have dummy regulator
support enabled.

How is the CODEC driver supposed to know if 'vaux' is actually present?
Because if it isn't present, the driver wouldn't declare support for
8000x  rates.
regulator_get() would always succeed, and regulator_is_enabled() would
always return 1, even if the vaux is not supplied.

Thanks,
-Jassi
