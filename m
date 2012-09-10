Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2IJL3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:29:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59848 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2IJL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <201209101013.16697.arnd@arndb.de>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<201209071358.38598.arnd@arndb.de>
	<CACRpkdZ-QpHzeEBO=RFVe-8S2DG4-thhwW9iVbAMXZrOe-FnAw@mail.gmail.com>
	<201209101013.16697.arnd@arndb.de>
Date: Mon, 10 Sep 2012 04:29:29 -0700
Message-ID: <CACRpkdbPwiaF8tfEE7NNd_KE3VGtVx-pPwL-HObhh3fRYXqH=g@mail.gmail.com>
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 3:13 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> I think it's fine to do the device driver conversion separately
> from the platform changes, but doing that properly means that the
> platform changes should only go in after the drivers have changed.

OK, in the diffstat we're discussing we have this:

 drivers/gpio/gpio-tc3589x.c            |  120 +++++++++++++++++++--------
 drivers/i2c/busses/i2c-nomadik.c       |    4 +
 drivers/mfd/mfd-core.c                 |   10 ++-
 drivers/mfd/tc3589x.c                  |  112 +++++++++++++++++++------
 include/linux/mfd/tc3589x.h            |    1 +

> Inside of the platform code, I absolutely think we should change the
> board file and the dts file simultaneously.

Sure, no problem. But this patch series might have a title
problem, as it is not isolated to the platform code at all.

> When the driver offers
> two ways of probing a device, this lets us change from one way to
> the other without going through a phase where we use neither of them
> or (worse) both at the same time.

Maybe unrelated, but as usual it works as long as there are no
DMA channels or callback functions :-/

The MMC, PL022 patches in this patch set: both need
AUXDATA and DT data simultaneously due to DMA channels
and callbacks passed in as AUXDATA.

Yours,
Linus Walleij
