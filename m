Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152Ab2JaIqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:46:48 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:33683 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935082Ab2JaIqn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:46:43 -0400
From: Loic PALLARDY <loic.pallardy@st.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Juan Gutierrez <jgutierrez@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Suman Anna <s-anna@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 31 Oct 2012 09:45:09 +0100
Subject: Re: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap headers
Thread-Topic: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap
 headers
Thread-Index: Ac23RAlWHq77R8XqRVeOishPL2CzKg==
Message-ID: <5090E515.9050407@st.com>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
 <1351530381-11459-2-git-send-email-omar.luna@linaro.org>
 <20121029175228.GD11908@atomide.com>
 <CALLhW=4ukBuRSVcPm2A37PgBhv33yKqk2G=Dz2XTUyswXw=JMg@mail.gmail.com>
 <20121030162441.GF11908@atomide.com>	<20121030210213.GA6098@kroah.com>
 <CALLhW=6p06MPdfbD2S-PRs=w0zLNsEifsJ2xL0hjEZaFpbadDA@mail.gmail.com>
In-Reply-To: <CALLhW=6p06MPdfbD2S-PRs=w0zLNsEifsJ2xL0hjEZaFpbadDA@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Omar,

On 10/31/2012 08:22 AM, Omar Ramirez Luna wrote:
>
> As part of plat-omap code cleanup, I was planning to move omap-mailbox
> framework to a newly drivers/mailbox folder, right now this code is
> specific to OMAP platforms, but with some clean up it could be the
> base for a generic framework. And living under drivers/mailbox could
> give it some exposure for interested developers to give feedback and
> propose changes.
>
> In the past there was a mailbox-like driver in mach-ux500, I was
> hoping both could live under the same folder, however the platform
> using it, was dropped a couple of kernel releases back and with it the
> other similar mailbox implementation.

On STE side, we are working on a mailbox driver which will rely on 
mailbox framework.
However some modifications in current Omap mailbox framework are needed 
to fit STE HW specificities.
- API naming should be generic (replace omap prefix by mailbox)
- message type should be enhanced
- fifo mechanism is linked to Omap maibox, not needed in STE case since 
it relies on cross interrupt + shared memory
I already have modifications I'll send you to see how we can create a 
common and generic mailbox framework.

Regards
Loic