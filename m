Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab1ERKgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:36:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43477 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab1ERKgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:36:18 -0400
MIME-Version: 1.0
Date: Wed, 18 May 2011 12:36:17 +0200
Message-ID: <BANLkTikAzjmVoNK20RHRkhHkn3YgSra6dA@mail.gmail.com>
Subject: Smartcard/SIM card subsystem, LDO regulator and signal modelling
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Bibek BASU <bibek.basu@stericsson.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Juergen Beisert <jbe@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I have this special regulator in the AB5500 which we will attempt to
submit for mainline inclusion soon:

It's basically an LDO for powering a SIM card (which in turn is basically
a smartcard), but apart from plain regulation also expose some other
electrical properties of the interface to software:

- Select pull-up resistance on some I/O lines
- Select weak pull-down on some data lines
- Select load capacitance limits on the data lines
- Select whether to run in low impedance or transmission gate mode

I think these will be mostly similar so what other SIM card controllers
will need to have. All the stuff needs to have userspace interfaces
since the stuff is usually controlled on behalf of another CPU
running the modem (and also performing the actual traffic on
the SIM data lines).

My first naïve idea was that this could be some plain regulator,
then add a few sysfs files for the custom stuff and have these
in the regulator driver.

However now I think we might even need to create a misc device
or a new drivers/smartcard/* subsystem, just that it will include
spawning a regulator for the LDO part. If drivers/smartcard/*
was created we'd easily fold into that, but since we're not
needing the generics of actually talking to the card we end
up in a strange place where we'd go implementing a
framework that we don't use and cannot test :-/

Maybe we should indeed create drivers/smartcard/*
and only add a tentative API for power & regulator
such as <linux/smartcard/power.h> or so?

Any thoughts on this, have you seen this before etc?

Also CC:ing some people with SoC systems that include a
SIM/smartcard reader ... RealView and Freescale comes to
mind.

Yours,
Linus Walleij
