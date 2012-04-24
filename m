Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2DXMfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:35:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64315 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2DXMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:35:30 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <DD6B9D658496A2488636C8C75B9C0CB601DA3AF6@EXMAIL04.scwf.nsc.com>
References: <1335107508.6261.3.camel@phoenix> <20120423110912.GC8318@opensource.wolfsonmicro.com>
 <CAF+7xWkzy5e0rcpwprEE3VWTikOu2+qtsgfdhTN12-yonDxadA@mail.gmail.com>
 <DD6B9D658496A2488636C8C75B9C0CB601DA3984@EXMAIL04.scwf.nsc.com>
 <CAF+7xWmB1YWjwmQmf9gk0DX7DH5euBD1QH8d7VW6r_nat8FwYQ@mail.gmail.com> <DD6B9D658496A2488636C8C75B9C0CB601DA3AF6@EXMAIL04.scwf.nsc.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 24 Apr 2012 20:35:09 +0800
Message-ID: <CAF+7xWnf6QMg5QeXyoRJH76xjprGW7B3pMXeS-f=uiwPdsMoLQ@mail.gmail.com>
Subject: Re: [PATCH] leds: lm3530: fix handling of already enabled regulators
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you explain what 'enabled on boot' means ?
> 1) The regulator_enable() is called in initial time
> or
> 2) boot_on = 1 in regulator_init_data ?
>
> If you mean 'boot_on = 1' in regulator_init_data, then no use_count increase.

I mean boot_on = 1 in regulator_init_data.

I just checked the regulator core, and you are right that
no use_count increase if boot_on = 1 in this case.

use_count will be increased if boot_on = 1 && using regulator_get_exclusive.

Regards,
Axel
