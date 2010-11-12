Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0KLJoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:44:14 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:58898 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018Ab0KLJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:44:12 -0500
Message-ID: <4CDD0C3D.5070309@stericsson.com>
Date: Fri, 12 Nov 2010 10:43:25 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@google.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
In-Reply-To: <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:

> I would advise against expanding the hardware counter to 63bits via
> software at the clocksource layer. This breaks the
> CLOCK_SOURCE_IS_CONTINUOUS flag rule (since the hardware will wrap
> below the mask value if not updated in the software layer). And as
> Thomas said, this will cause problems in the nohz idle limiting code
> (which makes sure we wake up before the clocksource wraps).

Hm, yeah that's probably the wisest thing to do right now..

Then the Tegra code is not quite sound. It will probably experience
bad stuff like shaky clocksource when idling too long.

> Instead, I'd use this extension at the sched_clock level, where it
> seems reasonable that it will be called frequently enough to not brake
> the cnt32_to_63 magic.

Yeah we will do it like the Orion does.

Thanks!
Linus Walleij
