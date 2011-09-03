Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1ICUIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 16:08:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40342 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1ICUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 16:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd8VUAZ1gL-MZx7y6+nORJ4m2U+SFyzF2duB-9NUcbqBQw@mail.gmail.com>
References: <CAKYAXd_QrgHHdiev-Vxt=FrwkJg-3qfjxzqkPmgLbwZ=U4358Q@mail.gmail.com>
	<CACRpkdYkk+W98RoCCwRWXyF+_1_H9gujxHLCPnqtPMn401fZvg@mail.gmail.com>
	<CAKYAXd8VUAZ1gL-MZx7y6+nORJ4m2U+SFyzF2duB-9NUcbqBQw@mail.gmail.com>
Date: Sat, 3 Sep 2011 22:08:05 +0200
X-Google-Sender-Auth: 5AQeSPVbF_0QQq5gpMt-8jBTBkA
Message-ID: <CAKnu2Mq=4Y=hiv-R7PvPyYCYmo9enu6_FPcoT089LxSa=_xMhw@mail.gmail.com>
Subject: Re: RFC : mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of multiple write blocks.
From: Linus Walleij <linus.walleij@linaro.org>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Kyungmin Park <kmpark@infradead.org>,
        Sebastian Rasmussen <Sebastian.Rasmussen@stericsson.com>,
        Ulf Hansson <Ulf.Hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/2 NamJae Jeon <linkinjeon@gmail.com>:

> We should consider DMA situation. As I know, host controller can not
> rise timeout interrupt in write not read in DMA status.

Which host controller are you talking about?

> host
> controller can just know whether card is finish to program to use busy
> line. If unstable card is holding busy line while writing using DMA,
> hang problem will happen by wait_for_completion.
> so I think that mmc driver need some exception to avoid this problem.

Yes you can add a timeout in the driver itself. Just set up
a common timer, no big deal.

Yours,
Linus Walleij
