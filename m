Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1FXNGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:06:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1FXNGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110624111929.GC9483@opensource.wolfsonmicro.com>
References: <1308862014-11212-1-git-send-email-jaswinder.singh@linaro.org>
	<20110624111929.GC9483@opensource.wolfsonmicro.com>
Date: Fri, 24 Jun 2011 18:36:10 +0530
Message-ID: <BANLkTi=pWMmfH+GV_kwm8_MtjPpsdNWD6w@mail.gmail.com>
Subject: Re: [PATCH] regulator: twl: Add 'fixed' set_voltage callback
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        ti@lists.linaro.org, linux-omap@vger.kernel.org, lrg@ti.com,
        sameo@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2011 16:49, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jun 24, 2011 at 02:16:54AM +0530, Jassi Brar wrote:
>> Define dummy set_voltage callback for fixed lines,
>> without which voltage constraints fail to apply.
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>
> No, this isn't sensible - fixed voltage regulators aren't an unusual
> property of this device, they've very common.  The core should handle
> this gracefully.  Probably whatever consumer is doing the setting also
> ought to be updated to check that the voltages it wants to set are
> supported at startup since

Well, there's no consumer in the picture yet. The core even fails to register
the regulator.
After digging deeper, I realized removing
       .apply_uV = true;
from the constraints is the correct solution. Patch is coming next.

> otherwise it can end up repeatedly trying to
> set something that'll never work.
Though the semantic could be defined that the 'closest' possible value
is already
set after the set_{voltage,current_limit} returns.
The consumer has no point in retrying - just like sample-rate setting
in Alsa works.

Thanks,
Jassi

-- 
Linaro.org │ Open source software for ARM SoCs | Follow Linaro
http://facebook.com/pages/Linaro/155974581091106  -
http://twitter.com/#!/linaroorg - http://linaro.org/linaro-blog
