Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1KYPmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 10:42:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41595 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1KYPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 10:42:17 -0500
Message-ID: <4ECFB755.6060509@gmail.com>
Date: Fri, 25 Nov 2011 16:42:13 +0100
From: Hubert Feurstein <h.feurstein@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Nikolaus Voss <n.voss@weinmann.de>
CC: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org,
        carsten.behling@garz-fricke.com
Subject: Re: [PATCH v7 0/5] AT91: replace broken TWI driver i2c-at91.c
References: <cover.1322062555.git.n.voss@weinmann.de>
In-Reply-To: <cover.1322062555.git.n.voss@weinmann.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've tested this driver on a 2.6.38 kernel with several i2c clients
(temp-sensor, audio-codec, touchscreen-controller, w1-bridge,
io-expanders) and works without problems. SoC: at91sam9g45

Because of the 2.6.38 kernel, I had to skip "[PATCH v7 2/5] Replace
clk_lookup.con_id with clk_lookup.dev_id entries for twi clk" and used
instead: at91_clock_associate("twi0_clk", &at91sam9g45_twi0_device.dev,
"twi_clk");

Best Regards
Hubert

On 2011-11-23 16:35, Nikolaus Voss wrote:
> The old driver has two main deficencies:
> i)  No repeated start (Sr) condiction is possible, this makes it unusable
>     e.g. for most SMBus transfers.
> ii) I/O was done with polling/busy waiting what caused over-/underruns
>     even at light system loads and clock speeds.
> 
> The new driver overcomes these deficencies and in addition allows for
> more than one TWI interface.
> 

Tested-by: Hubert Feurstein <h.feurstein@gmail.com>
