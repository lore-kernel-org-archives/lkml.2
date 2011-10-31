Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1JaVV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:21:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63262 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1JaVV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
References: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
Date: Mon, 31 Oct 2011 14:21:56 -0700
Message-ID: <CAF8ieYXPMgUzekth7PGxC3AgYNKac-HQ21D3vvB5J3SLOatmfQ@mail.gmail.com>
Subject: Re: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 9:14 AM, Voss, Nikolaus <N.Voss@weinmann.de> wrote:
> If pdata->scl_is_open_drain was set, the driver used push-pull output
> for SCL, not open-drain output.
>
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>

{sda,scl}_is_open_drain indicates that the GPIO hardware is set up to
do open drain so the software doesn't have to, i.e.
gpio_set_value(pin, 1) will turn off the output driver rather than
drive the pin high, so the _val functions will do the right thing.

In other words, the existing code is correct.

Havard
