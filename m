Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab1JCR4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:56:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29892 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757156Ab1JCR4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:56:13 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19WSM4ZmoC+h+f7JCbfcw1/
Date: Mon, 3 Oct 2011 10:56:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Paul Walmsley <paul@pwsan.com>,
        linux-omap@vger.kernel.org, "Avinash.H.M" <avinashhm@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/30] ARM: omap2+: fix building without i2c
Message-ID: <20111003175608.GS6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-9-git-send-email-arnd@arndb.de>
 <alpine.DEB.2.00.1110021928170.4611@utopia.booyaka.com>
 <1443629.oeLM18uNcs@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1443629.oeLM18uNcs@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [111003 02:15]:
> On Sunday 02 October 2011 19:31:25 Paul Walmsley wrote:
> 
> > Nice catch.  I think the bug is different, though.  omap_i2c_reset should 
> > never be NULL: that code is intended to execute even when 
> > CONFIG_I2C_OMAP=n.  The idea is to prevent the IP block from interfering 
> > with the rest of the kernel even if the driver is not compiled in, no 
> > matter how the bootloader or previous OS programmed the IP block.
> > 
> > I'd suggest something like the following patch instead.
> > 
> > 
> > - Paul
> > 
> > From: Paul Walmsley <paul@pwsan.com>
> > Date: Sun, 2 Oct 2011 19:15:10 -0600
> > Subject: [PATCH] ARM: omap2+: fix build breakage when CONFIG_I2C_OMAP=n
> > 
> > arch/arm/mach-omap2/Makefile incorrectly skips compilation of the I2C
> > IP block reset code when CONFIG_I2C_OMAP=n.  Fix by unconditionally
> > compiling arch/arm/mach-omap2/i2c.o, which is needed on all OMAP2+ platforms.
> > 
> > Problem noted by Arnd Bergmann <arnd@arndb.de>.
> 
> Ok, looks better. You should also drop patch 6 "ARM: omap: fix build with
> CONFIG_I2C_OMAP disabled" then.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Arnd I suggest you replace your patch with this in your branch.

Acked-by: Tony Lindgren <tony@atomide.com> 
