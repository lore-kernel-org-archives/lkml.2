Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab1CDKKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:10:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50414 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab1CDKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XdZK/336apRO1uQkP2IRYyEG+CHVOCjK2UFvRZDtCzaI2g5VCJRykIKiMguHb3VpiL
         QNoNWwszi/pTJki0llpJG8Dlc9fHoG8FAD+yqCV5dqeCvo82KkWZvPZtwZhPwvaliE7j
         Ggg4LocIlrjOgMp/1YjZc4GivKzXTu36myBmU=
MIME-Version: 1.0
In-Reply-To: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
References: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 4 Mar 2011 11:10:03 +0100
X-Google-Sender-Auth: J6n1L_LWkOdTFdJQWaUVODS4H8w
Message-ID: <AANLkTi=KU_zUrBsp0a9iJyj6RmTgYqZcffQynTV-2tKW@mail.gmail.com>
Subject: Re: [PATCHv4 0/4] ARM: Fixing udelay() for SMP and non-SMP systems
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mattias Wallin <Mattias.Wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Stephen Boyd <sboyd@codeaurora.org>:

> These patches fix the udelay() issue pointed out on
> arm-lkml[1][2]. A quick recap: some SMP machines can scale
> their CPU frequencies independent of one another. loops_per_jiffy
> is calibrated globally and used in __const_udelay(). If one CPU
> is running faster than what the loops_per_jiffy is calculated
> (or scaled) for, udelay() will be incorrect and not wait long
> enough (or too long). A similar problem occurs if the cpu
> frequency is scaled during a udelay() call.

Hwt's happening to this patch set? We have applied it and
implemented a timer for the U8500.

Tested-by: Linus Walleij <linus.walleij@linaro.org>

Mattias WALLIN can probably also provide a Tested-by:
from ST-Ericsson if it helps.

Generally I think this is good and important stuff that should
be merged, will you be submitting it to Russells patch tracker
or pull request for 2.6.39?

Yours,
Linus Walleij
