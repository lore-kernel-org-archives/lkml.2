Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2HUBV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:21:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54952 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2HUBVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:21:24 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1345477150-25933-1-git-send-email-swarren@wwwdotorg.org>
References: <1345477150-25933-1-git-send-email-swarren@wwwdotorg.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 21 Aug 2012 09:21:03 +0800
Message-ID: <CAF+7xWkbB3N5BA=mJNxfLLuZhgtLWG2ugdbF5a+WoBiWa9mwQQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: max8907: fix compile error when !CONFIG_OF
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +static inline struct regulator_init_data *match_init_data(int index)
> +{
> +       return NULL;
> +}
> +

Now match_init_data() returns NULL if !CONFIG_OF, so idata may be NULL.

Then I think we may hit NULL pointer dereference here:

                switch (pmic->desc[i].id) {
                case MAX8907_MBATT:
                        mbatt_rail_name = idata->constraints.name;
                        break;

Regards,
Axel
