Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2EDVDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:03:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab2EDVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:03:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Handling of modular boards
Date: Fri, 4 May 2012 21:03:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Wolfgang Denk <wd@denx.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-embedded@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Igor Grinberg <grinberg@compulab.co.il>,
        Olof Johansson <olof@lixom.net>, Lee Jones <lee.jones@linaro.org>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <201205042039.25794.arnd@arndb.de> <20120504205441.D293120645E@gemini.denx.de>
In-Reply-To: <20120504205441.D293120645E@gemini.denx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042103.34285.arnd@arndb.de>
X-Provags-ID: V02:K0:/ZJ+c8iM/moKkzxpg5bbLAGqAgf+ym2o95Kf+LNU0DF
 q769YhAE0JbxN2pdpKNjMwUyv73nvgqgsN7I7H2zi1v3woRKTa
 ADc+8ULTWXZ6ks0rtNH0PKORKcxxTFi7uY9/ukfZ+KHeNLQlFT
 eOqFHoTYx7Y0EZ+B/wV+7vYJGVU61NQaJgdGx7eI7uLdh2IM26
 sVlkh4HQGtYbAvWcyXQFmPU3sorQcQEgGuLAhzxW9xgj7pHqN0
 P86ti4xQWzyHcRzd4DeeQjoSDraK5PCO0yIglusiqJ3RwYImSX
 ky4AGiT7q4CIxjRZLUAom8RfuEac4gQAtbVWrnf4uWSl5ent27
 dTsosOtb9MgfRfem/GAE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Wolfgang Denk wrote:
> There are systems (and I bet it will be a growing number) where U-Boot
> itself uses the DT for configuration.  Also, there are functions that
> are needed both by the boot loader and the kernel - for example to
> dislay a splash screen the boot loader needs to initialize the
> display, so it must be able to detect which type of LCD is attached
> (resolution, color-depth, orientation) - the device tree comes in very
> handy here.  Why should Linux re-do all such things?

Sure, there are a lot of things that the boot loader can use from the
device tree, but I'm not sure if the LCD panel connection fits into
the same category as the devices that Mark was thinking of.

Anyway, display controllers are definitely something that needs to
be handled in some way, which may or may not be the same way we
handle more complex collections of arbitrary devices.

	Arnd
