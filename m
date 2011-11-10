Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965186Ab1KJQeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:34:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7179 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964902Ab1KJQeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:34:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 10 Nov 2011 08:34:00 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Nov 2011 08:33:59 -0800
Subject: RE: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
Thread-Topic: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
Thread-Index: AcyfhGFzRTYH4Wr1RtCzAG5hD5gajQAQVpjA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805421@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17408051C2@HQMAIL01.nvidia.com>
 <CACRpkdY8YXooD5ChHqQnERPPGhk7TgUvL=TodAPY8Jit9eS=fw@mail.gmail.com>
In-Reply-To: <CACRpkdY8YXooD5ChHqQnERPPGhk7TgUvL=TodAPY8Jit9eS=fw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, November 10, 2011 1:40 AM:
> On Wed, Nov 9, 2011 at 9:34 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > I'm curious about any pinctrl-related discussions that happened at Linaro
> > Connect. Are you able to summarize any discussions/decisions, or point me
> > at some existing summary? Especially anything to do with the new pin config
> > options, possibly extending the mapping table to control them, etc.
> 
> There was not much of discussion really, and I didn't have any specific
> pinmux session. It seems like most people with an interest in this were
> in Prague, none in Orlando...
> 
> I'll make a patch with some kind of solution that I intutively came up
> with, then we will probably refactor that a few good times before the
> next merge window.
> 
> > Many drivers currently call gpio_request(). This is defined /not/ to
> > perform any pinmux manipulation.
> 
> Is it?
> 
> I always though that the GPIO driver could call out to the pinctrl
> counterpart.

I'd originally thought that too, but when I tried to "fix" gpio_request()
on Tegra to perform any necessary pinmux actions, it was pointed out that
Documentation/gpio.txt says:

" Note that requesting a GPIO does NOT cause it to be configured in any
" way; it just marks that GPIO as in use.  Separate code must handle any
" pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
                              ^^^^^^^^^^^^^^^^^^^^^^^

Given that, it appears that the pinctrl/pinmux API is the way to perform
that setup, including muxing the GPIO controller onto the pin if required.
Given the similarity of that mux setup with more general non-GPIO mux
setup is why I suggested including GPIO muxing in the regular mapping
table.

(as I think I mentioned) and alternative to a custom GPIO mapping table
entry would be to remove the GPIO-specific APIs from pinctrl, and have
all pinctrl drivers only expose GPIO as an additional function available
on a pin (group). Systems that support N different GPIOs on a pin would
need to expose GPIO this way anyway.

-- 
nvpublic

