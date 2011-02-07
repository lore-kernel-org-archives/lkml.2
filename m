Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1BGT7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:59:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:53554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1BGT7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yvZ8Z5PurN4C8K+dcTneBNwhBFQ0UB2dHOaNVpGvL5F2A8IVSg3BScRBamOj/rO+pc
         0Mxh4vluPQr3siiO+QGQ==
MIME-Version: 1.0
In-Reply-To: <1297058877.800158.458894385837.1.gpush@pororo>
References: <201102011711.31258.jeremy.kerr@canonical.com>
	<1297058877.800158.458894385837.1.gpush@pororo>
Date: Mon, 7 Feb 2011 11:59:26 -0800
Message-ID: <AANLkTi=5FNvWKQf6cRt4wNejC7u4XKsqLp9Pwc2Z45_3@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
From: Colin Cross <ccross@google.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 10:07 PM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
<snip>

> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> new file mode 100644
> index 0000000..12e0daf
> --- /dev/null
> +++ b/drivers/clk/clk.c

<snip>

> +int clk_enable(struct clk *clk)
> +{
> +       int ret = 0;
> +
> +       if (!clk->ops->enable)
> +               return 0;
> +
> +       spin_lock(&clk->enable_lock);

spin_lock_irqsave/spin_unlock_irqrestore.  This could get called with
irqs on or off.
