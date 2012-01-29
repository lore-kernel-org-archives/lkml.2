Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2A2JnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 04:43:13 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61531 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab2A2JnM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 04:43:12 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1327804218.16295.1.camel@phoenix>
References: <1327804218.16295.1.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 29 Jan 2012 17:42:51 +0800
Message-ID: <CAF+7xWn2AkcEyOb5FmXNbGA7U2=n83kvAz+=GGLMh+8yNm8UKw@mail.gmail.com>
Subject: Re: [PATCH] regulator: Add empty devm_regulator_free for !CONFIG_REGULATOR
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline void devm_regulator_free(struct regulator *regulator)
> +{
> +}
> +

Oh wait.
I found commit d5ad34f7cb "regulator: Implement devm_regulator_free()"
has declared devm_regulator_free in include/linux/regulator/consumer.h
But it actually implements devm_regulator_put instead of devm_regulator_free.

Mark, I guess what you want is to declare devm_regulator_put instead
of devm_regulator_free
in consumer.h.

Regards,
Axel
>  static inline int regulator_enable(struct regulator *regulator)
>  {
>        return 0;
> --
> 1.7.5.4
>
>
>
