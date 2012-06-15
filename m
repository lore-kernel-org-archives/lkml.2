Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2FOOue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:50:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63522 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2FOOud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:50:33 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 15 Jun 2012 22:50:12 +0800
Message-ID: <CAF+7xWnM9Z2eBAiuSidW9AUfo+M4-JHHzN3jgn+1bwH3he3rAQ@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: add new regulator driver for lp872x
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct regulator_init_data
> +*lp872x_find_regulator_init_data(int idx, struct lp872x *lp)
> +{
> +       int i;
> +       int base = lp->chipid == LP8725 ? LP8725_ID_BASE : 0;
> +       int id = idx + base;
> +
> +       for (i = 0 ; i < LP872X_MAX_REGULATORS ; i++)

LP872X_MAX_REGULATORS is 9.
But for LP8720, the LP8720_NUM_REGULATORS is 6.
So this should be:
        for (i = 0 ; i < lp->num_regulators  ; i++)
