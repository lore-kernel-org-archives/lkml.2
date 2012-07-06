Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2GFGzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:55:52 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:64749 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2GFGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-4-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-4-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 08:55:49 +0200
Message-ID: <CACRpkdbRtFX8_++rndCpsH7R1uhwPrkTE_GKgNTM6r1PSuwY0A@mail.gmail.com>
Subject: Re: [PATCH 3/9] ARM: ux500: Remove AB8500 regulator register
 initialisation information
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Mattias WALLIN <mattias.wallin@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> There is no need to initialise the AB8500's regulator registers, as
> most of this work is already carried out by framework features, so
> we can safely remove all traces from platform code.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

NACK, sorry.

These registers are used to set up sleep states for the regulators,
e.g that some regulators will turn off when the system go to sleep.

If you delete this code it's no longer possible to make the system
powerefficient, power consumption increases so it causes a
regression.

The proper thing to do is to take the AB8500 datasheet, go in and
read what these registers actually do, and provide the same
features through the framework, if just poking the registers
is deemed non-elegant (I see the point in that).

This is the AB8500 datasheet:
http://www.stericsson.com/developers/CD00291561_UM1031_AB8500_user_manual-rev5_CTDS_public.pdf

So please refactor this, don't just delete, that's destroying a lot
of useful stuff.

Yours,
Linus Walleij
