Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1FYVEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:04:41 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50602 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1FYVEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikt3YRO1fYRZNzHpygZxRdxK4x-bA@mail.gmail.com>
References: <1308763983-24749-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTikt3YRO1fYRZNzHpygZxRdxK4x-bA@mail.gmail.com>
Date: Sat, 25 Jun 2011 23:04:39 +0200
Message-ID: <BANLkTinQ6EZ9_Bh92SZswtyTax0LSJFX+w@mail.gmail.com>
Subject: Re: [PATCH 1/3] leds: create a trigger for ARM CPU activity
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 25, 2011 at 3:42 AM, Bryan Wu <bryan.wu@canonical.com> wrote:

> I've been thinking about moving the arm led_event interface to
> drivers/leds/. And maybe other machines can simply benefit from this
> trigger driver, since the led_event interface is actually not really
> ARM specific.
>
> So what about add a new trigger just named ledtrig-cpu.c which can be
> shared by other machines as well as ARM monsters.

Well I don't know about that. The ARM CPU LED triggers mess around
in arch/arm/kernel/process.c to insert a callback whenever the idle
state is entered or exited for a CPU in cpu_idle(). I don't know if that
is something other archs would like to copy to get working CPU usage
LED indicators.

Also leds_event is a global callback which is pretty brutal,
for example right now the driver hogs that callback, noone else can
use it. (Well if only used for CPU maybe that's natural.)

I mainly moved the machine part of this code to consolidate it, but
let's ask on LKML to see if there is some general interest in this,
for the moment I suggest we go with ARM CPU leds, it's easy enough
to amend by just renaming the file and Kconfig text the day some other
CPU wants to do this.

Linus Walleij
