Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab2JXGhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:37:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34613 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933613Ab2JXGhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121024055137.GC9787@avionic-0098.mockup.avionic-design.de>
References: <1350904001-7621-1-git-send-email-shiraz.hashim@st.com>
	<20121024055137.GC9787@avionic-0098.mockup.avionic-design.de>
Date: Wed, 24 Oct 2012 12:07:19 +0530
Message-ID: <CAKohpomectx_7Ox5os-MEA7iGsLQbDMQ_7ryuFyD437uf_Dmbg@mail.gmail.com>
Subject: Re: [PATCH V4] PWM: Add SPEAr PWM chip driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 11:21, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Mon, Oct 22, 2012 at 04:36:41PM +0530, Shiraz Hashim wrote:
>> +     ret = pwmchip_add(&pc->chip);
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
>> +             return ret;
>> +     }
>> +
>> +     ret = clk_prepare_enable(pc->clk);
>> +     if (ret < 0)
>> +             return pwmchip_remove(&pc->chip);
>
> I think in order to fix the potential race condition that Viresh
> mentioned we should move the clk_prepare_enable() before the
> pwmchip_add(), but don't forget to disable and unprepare the clock if
> pwmchip_add() fails.
>
> Actually, can't we make it a clk_prepare() only at this point and move
> the clk_enable() and clk_disable() into the if block below? In case the
> compatible value is not "st,spear1340-pwm" we don't need the clock
> enabled.

We should. I should have given this comment earlier.

--
viresh
