Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab0GNWvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:51:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57049 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab0GNWvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vvenhb+X/gqzkLCxX95BROoK0yXYHaV5kyFsOFLC1jRxitUKpAyI95Y7711GnMDiYk
         W1NIE22V1UPtkkN/4IuMM1KpSh+LWt2fsCdQl+PcsZUigm/aOpZPG3sUOSm1YTGjAkJU
         ohD92MLWRtU6VO6r0iBGJR66p17riLErPpIbs=
MIME-Version: 1.0
In-Reply-To: <20100714184251.GG5933@sirena.org.uk>
References: <20100713203852.GA1756@rakim.wolfsonmicro.main>
	<20100714145053.GA1689@bnru01.bnr.st.com>
	<20100714145748.GF31073@rakim.wolfsonmicro.main>
	<20100714153643.GB1689@bnru01.bnr.st.com>
	<20100714154726.GH31073@rakim.wolfsonmicro.main>
	<20100714160941.GC1689@bnru01.bnr.st.com>
	<20100714162048.GA27512@rakim.wolfsonmicro.main>
	<20100714164708.GD1689@bnru01.bnr.st.com>
	<20100714170323.GF5933@sirena.org.uk>
	<20100714173650.GA21893@bnru01.bnr.st.com>
	<20100714184251.GG5933@sirena.org.uk>
Date: Thu, 15 Jul 2010 00:51:50 +0200
X-Google-Sender-Auth: RJ-xZMHHimariSaGw_Xbq7V2SD8
Message-ID: <AANLkTimWjozzhTG491JVLUIICh6YonO4Emp07AG1nMj-@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific data
From: Linus Walleij <linus.walleij@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:

>> > This is normal, but for fairly obvious reasons the very lowest power
>> > states are generally handled outside of the regulator API at a hardware
>> > level via hardware signals to the regulator.  It's not normally part of
>> > the runtime constraints for use while the CPU is live.
>
>> Yes. But my point was that even at a lower level than kernel (BIOS/firmware?)
>> the switching would happen via SW. Please correct me if I am wrong!
>
> Well, ultimately it's always triggered by software but the actual signal
> to the regulator is often a logic level output by the SoC as the
> processor enters a low power state rather than an I2C/SPI write.

I can answer this: on the U300 we had such autonomous signals that
would augment the power state of the regulators by special sleep
signals.

For U8500 there is a dedicated autonomous system in the silicon, called
PRCMU (Power Reset Clock Management Unit) that will actually do
this using I2C because it has its own CPU and can transmit I2C
messages even when the ARM CPU cores are turned off. So this is
indeed a first-timer and not strange that it looks unfamiliar ...

Yours,
Linus Walleij
