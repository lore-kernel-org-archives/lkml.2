Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1BXMfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:35:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58512 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1BXMfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OKv/e5BALsErkExmKeRhcH+mSs7Q04SW8LZzbTzC88sMgp43CHOfUw5zP8KdsWj13j
         J95YL1SRMvVgmhhoTKciy1aOByk2u57MzB8da75PFK51i/H1iox1ApmWAOVIVQDXtYk2
         9avwngRScLnQSbpNzs751FdKYmNoHx6xffQrs=
MIME-Version: 1.0
In-Reply-To: <20110224111801.GA7169@intel.com>
References: <20110224111801.GA7169@intel.com>
Date: Thu, 24 Feb 2011 13:35:46 +0100
X-Google-Sender-Auth: nHGtQ-UyKfef5vpv9mG2eAtCo14
Message-ID: <AANLkTik8B0c0Bfv2O2-vcNUGGitywRjUXrGE44kP1cq4@mail.gmail.com>
Subject: Re: [PATCH 1/1]mmc: fix division by zero when calculate mmc erase time
From: Linus Walleij <linus.walleij@linaro.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, adrian.hunter@nokia.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/24 Chuanxiao Dong <chuanxiao.dong@intel.com>:
> Since if clock gating feature is enabled, the clock frequency may be zero when
> host clock is gated. In such scenario, mmc_set_mmc_erase_timeout() may have a
> division by zero bug.
>
> So this patch used mmc_host_clk_rate() to fix this.
>
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Actually I think these divide-by zero bugs were there before since clock
0 is perfectly legal, we just didn't trigger them before.

Yours,
Linus Walleij
