Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1DEQ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:28:49 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:14054
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab1DEQ2s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:28:48 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 12:28:48 EDT
X-SpamScore: -20
X-BigFish: VS-20(zzbb2dK9371P1432N98dKzz1202hzzz2dh2a8h637h668h839h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4D9B3FA8.1010407@freescale.com>
Date: Tue, 5 Apr 2011 13:13:28 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, <kernel@pengutronix.de>
Subject: Re: [PATCH] leds: provide helper to register "leds-gpio" devices
References: <20110405073030.GI13963@pengutronix.de> <1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On 4/5/2011 5:37 AM, Uwe Kleine-König wrote:
> This function makes a deep copy of the platform data to allow it to live
> in init memory.
> The definition cannot go into leds-gpio.c because it needs to be builtin
> to be usable by platforms.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

I tested your patch on a MX53EVK board, but I could only build it after unselecting the mmc driver.

This is the error I got when mmc was selected:

  CC      drivers/mmc/card/mmc_test.o
  LD      drivers/mmc/card/built-in.o
  CC      drivers/mmc/core/sdio_io.o
In file included from include/linux/mmc/host.h:13,
                 from drivers/mmc/core/sdio_io.c:12:
include/linux/leds.h:220: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'gpio_led_register_device'
make[3]: *** [drivers/mmc/core/sdio_io.o] Error 1
make[2]: *** [drivers/mmc/core] Error 2
make[1]: *** [drivers/mmc] Error 2
make: *** [drivers] Error 2

Regards,

Fabio Estevam


