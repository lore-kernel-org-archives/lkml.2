Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab1BANGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:06:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53833 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1BANF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EnSewu8a6j8JYQR3l1MHL0KW+p1Tl+R8NCsEQql3v7dm3OovEwhZGAtDWZCT/hpwM3
         KtMivkXlR14fYD+NQbhUuGtV57fLkx9N+WdsYuIMt6aEDGFY2UmhJrD+HWoPQEvhqi0p
         xUXQblAL78Z1yPHNWuxaDqWEYgm+mPQ6aPlgo=
MIME-Version: 1.0
In-Reply-To: <20110201105449.GY1147@pengutronix.de>
References: <201102011711.31258.jeremy.kerr@canonical.com>
	<20110201105449.GY1147@pengutronix.de>
Date: Tue, 1 Feb 2011 22:05:56 +0900
Message-ID: <AANLkTimayMAfr+zA6uO_yUmZqsOLmJ3fiiS696mL_evn@mail.gmail.com>
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
From: Jassi Brar <jassisinghbrar@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/1 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:

.....

> Do you plan to handle the case that clk_enable is called while prepare
> isn't completed (considering the special case "not called at all")?
> Maybe BUG_ON(clk->ops->prepare && !clk->prepare_count)?
Sounds better than the second option.

> Alternatively don't force the sleep in clk_prepare (e.g. by protecting
> prepare_count by a spinlock (probably enable_lock)) and call clk_prepare
> before calling clk->ops->enable?
That might result in a driver working on some platforms(those have
atomic clk_prepare)
and not on others(those have sleeping).


Njoi!
