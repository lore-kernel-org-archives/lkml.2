Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1EaVS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:18:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36604 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab1EaVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <4DE51EB7.7010606@stericsson.com>
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>
	<alpine.LFD.2.02.1105311236250.3078@ionos>
	<4DE51EB7.7010606@stericsson.com>
Date: Tue, 31 May 2011 23:18:25 +0200
Message-ID: <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 7:00 PM, Mattias Wallin
<mattias.wallin@stericsson.com> wrote:
> On 05/31/2011 12:38 PM, Thomas Gleixner wrote:

>>> +++ b/include/linux/clksrc-db8500-prcmu.h

>> Huch, why needs this to be a separate head in include/linux ?
>
> I will move the header file to mach-ux500/include/mach/. Ok?
>
> (I have long time ago been thought to avoid include mach headers from the
> drivers. But if I understand it correct it is not true any more and in this
> case it certainly makes no sense since I break that rule myself.)

Keeping it under include/linux is probably wise since we want drivers
OUT of the ARM tree, but I don't know if there is much consensus on that?

I was more understanding the question as why it was needed at all.

Does it work to register the clocksource with say a core_initcall()
and avoid the header altogether?

Else a header is needed since we need to call out from the platform timer
init function to this clocksource to register it.

Thanks,
Linus Walleij
