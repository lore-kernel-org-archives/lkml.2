Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab1JTJyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:54:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41800 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1JTJyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4z3xs3CrKM37R_=NG3dhSrmWqxFq9f52zPQ3OATLns4oQ@mail.gmail.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
	<1319062768-26391-2-git-send-email-swarren@nvidia.com>
	<CAGsJ_4z3xs3CrKM37R_=NG3dhSrmWqxFq9f52zPQ3OATLns4oQ@mail.gmail.com>
Date: Thu, 20 Oct 2011 11:54:08 +0200
Message-ID: <CACRpkdY09qAog4soXf12w71vbk9EX3dvE_0Kuisw4iai9+rDXA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: Remove unsafe __refdata
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:46 AM, Barry Song <21cnbao@gmail.com> wrote:

> 2011/10/20 Stephen Warren <swarren@nvidia.com>:
>> A pin controller's pin definitions are used both during pinctrl_register()
>> and pinctrl_unregister(). The latter happens outside of __init/__devinit
>> time, and hence it is unsafe to mark the pin array as __refdata.
>
> Thanks.
> Acked-by: Barry Song <Baohua.Song@csr.com>
>
> missed this when porting prima2 pinmux driver. is this __refdata used
> just due to a typo?

No the problem was I misunderstood what __refdata means.

It means it is kept around but can reference initidata.

But I thought it meant "kept around in general".

I don't think it's causing bugs actually because it wasn't referencing
any initdata. But it's better like this.

Thanks,
Linus Walleij
