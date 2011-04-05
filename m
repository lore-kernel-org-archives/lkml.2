Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1DEWWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 18:22:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1DEWWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 18:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fqWoEW3S7qvR/cbJ1Rd/6JOVtiLaixbg1+tjBzRIGKhkwxq4fUMu+uaiRs+Tjm9lkO
         9cDIaLvyl5KoQb6Civ9vbOF0FHvzVuH062eDrzQrEAqFC6PJMPJti4WQ4v1jhSzGI07b
         jT5WJxPWhtQ2z+7oIlVaVNFqDNf0mkrp0wuCM=
MIME-Version: 1.0
In-Reply-To: <4D9AB958.5010304@ti.com>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	<201104031726.37420.arnd@arndb.de>
	<20110403160324.GA8050@n2100.arm.linux.org.uk>
	<201104040259.26601.arnd@arndb.de>
	<1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
	<20110404112104.GB19854@n2100.arm.linux.org.uk>
	<1301923457.417.34.camel@e102391-lin.cambridge.arm.com>
	<20110404133104.GA23266@n2100.arm.linux.org.uk>
	<1301925445.417.54.camel@e102391-lin.cambridge.arm.com>
	<BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com>
	<4D9AB958.5010304@ti.com>
Date: Wed, 6 Apr 2011 00:22:15 +0200
X-Google-Sender-Auth: dR5Ub8ufxhb5GN_8DzlEX1EV7cM
Message-ID: <BANLkTins_YaNYSRc1ryZuRSnGKO2MEemuA@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Linus Walleij <linus.walleij@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Detlef Vollmann <dv@vollmann.ch>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/5 Santosh Shilimkar <santosh.shilimkar@ti.com>:

> The only issue I see is the clock-events implemented using
> local timers capabilities in low power modes. The local timers
> won't be able wakeup CPU from DORMANT or OFF state and hence
> you will need an additional wakeup capable clock-event
> working together with the local timers using clock-notifiers.

And this is because the IRQs it emits are local and thus cannot wake
the system? This sounds way backwards... A simple naïve solution
would have been to just route out an external IRQ line back from a
selected timer and into the GIC so it will be able to wake up the
system, right?

Yours,
Linus Walleij
