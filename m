Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1EJIyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:54:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45482 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab1EJIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=D7X8oVvI2nKiFhuJccnXWTGGFmJp1qsCAz269nUGpQONRHg7iqsJBEDjGAW3207lK/
         0fomgcXk1kzSPTy2xzFcx9sbXPmAeVtGRRfGYUfVyHb1Q16y2MJht2ZjYc6IIG8I9fyy
         dlN2TSONnBcTXf3RicatniFIhTvr+7z0BZy94=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1304953437.3192.13.camel@odin>
References: <1304609578.5296.4.camel@phoenix> <1304953437.3192.13.camel@odin>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 10 May 2011 16:54:23 +0800
Message-ID: <BANLkTintTfzPnYuUtvJuEoAnmjf4_=K=KQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: Move VCOINCELL to be the last element of
 mc13892_regulators array
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Liam,

> Applied, Btw is this fix also for 2.6.39 ?

I check this patch again and found this actually is not a bug
because MC13xxx_DEFINE explictly defines the order of each entry in the array.

#define MC13xxx_DEFINE(prefix, _name, _reg, _vsel_reg, _voltages, _ops) \
        [prefix ## _name] = {                           \
                .desc = {                                               \
                        .name = #prefix "_" #_name,                     \
                        .n_voltages = ARRAY_SIZE(_voltages),            \
                        .ops = &_ops,                   \
                        .type = REGULATOR_VOLTAGE,                      \
                        .id = prefix ## _name,          \
                        .owner = THIS_MODULE,                           \
                },                                                      \
                .reg = prefix ## _reg,                          \
                .enable_bit = prefix ## _reg ## _ ## _name ## EN,       \
                .vsel_reg = prefix ## _vsel_reg,                        \
                .vsel_shift = prefix ## _vsel_reg ## _ ## _name ## VSEL,\
                .vsel_mask = prefix ## _vsel_reg ## _ ## _name ## VSEL_M,\
                .voltages =  _voltages,                                 \
        }

Regards,
Axel
