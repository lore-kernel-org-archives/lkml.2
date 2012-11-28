Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2K1V04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:26:56 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64316 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab2K1V0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:26:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh2x=mTzMVykRymid_TKG8Y87GpuD9V1KZ0YyzmfY4GHtqydg@mail.gmail.com>
References: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
 <CAOh2x=kw11+fGK6G_fKm2CA3TNGnG_mFq1eHeNxQ-B97-Wd_NA@mail.gmail.com> <CAOh2x=mTzMVykRymid_TKG8Y87GpuD9V1KZ0YyzmfY4GHtqydg@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 28 Nov 2012 22:26:12 +0100
X-Google-Sender-Auth: Sd0R5Zyk-puOyRUF6O9-_NJUtKc
Message-ID: <CAH+eYFBkroHY2dEv_fL_Ai-r8H9wR6njrsDvPEGRdfoGEzN7wA@mail.gmail.com>
Subject: Re: [RFC 1/2] clk: use struct clk only for external API
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/28 viresh kumar <viresh.kumar@linaro.org>:
> On Wed, Nov 28, 2012 at 9:31 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
>> On Wed, Nov 28, 2012 at 5:22 PM, Rabin Vincent
>> Isn't something wrong here? For common clk case shouldn't
>> this be:
>>
>>> +#define clk_to_clk_core(clk)  (&clk->clk)
>>> +#define clk_core_to_clk(core) (container_of(clk, ...))  //not getting into the exact format here
>>
>> Sorry, if i am missing basics.
>
> Ok. I saw these getting updated in 2/2. But it means this individual patch
> is broken and this is not allowed i believe.

It would be better to use container_of / &clk->clk, yes.  I wouldn't
really describe it as "broken" though since it works fine as it is,
since it's the first and only element.  I will change it anyway.
