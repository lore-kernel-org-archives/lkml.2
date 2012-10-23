Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2JWRCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:02:25 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:33627 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab2JWRCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:02:23 -0400
Message-ID: <5086CD91.9070101@firmworks.com>
Date: Tue, 23 Oct 2012 07:02:09 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com> <20121022155028.GA13791@core.coreip.homeip.net> <CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com> <508664CA.7000601@ti.com> <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com> <20121023100333.GA24418@arwen.pp.htv.fi>
In-Reply-To: <20121023100333.GA24418@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q9NH2AMW000634 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 12:03 AM, Felipe Balbi wrote:
> Hi,
> 
> I much prefer having drivers explicitly manage all their resources,
> which would mean that pinctrl calls need to be done on probe() and, if
> necessary, during suspend()/resume().


Per-driver resource management is certainly convenient when you are
dealing with a single system, but it becomes difficult to maintain for
drivers that are shared among many platforms.

The industry trend for many years has been consolidation around a single
programming model per class of device.  For example, SDHCI, EHCI, ATA.
This trend will only accelerate, as the cost of developing controller IP
and associated drivers increases.  Such drivers need to be as
platform-agnostic as possible.

