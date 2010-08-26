Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0HZFRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 01:17:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62632 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab0HZFRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 01:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OOdeyQcobEY2eo88i2cHtVZNY/ZBfFgAbJ+IdI2F6uNRa0wd1l+99aBNnqAlEUm5bM
         n005y9/D96cbAUr+dRS6/b6iRpTJonWOovrJLU/ieAmhV0ZfQkco1WirGN//Acs1KKa7
         Ggne1KcMq5iLK5DQ7aisSm+ZBqyKlwDvDEWX0=
Date: Thu, 26 Aug 2010 09:17:05 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped
 controllers
Message-ID: <20100826051705.GA25521@oksana.dev.rtsoft.ru>
References: <20100825194249.GA453@oksana.dev.rtsoft.ru>
 <921098.64431.qm@web180306.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <921098.64431.qm@web180306.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 05:11:23PM -0700, David Brownell wrote:
> From: Anton Vorontsov <cbouatmailru@gmail.com>
> Subject: [PATCH] gpio: Add generic driver for simple memory mapped controllers
> 
> NAK.  As you said, it matches the programming of
> certain FPGAs ... so it's NOT "generic".  Rename to match
> the Verilog/VHDL module name or somesuch, if there's
> really much reuse of that module.

I know at least two completely different platforms that
might reuse this driver.

One is PowerPC with ~10 different boards, and another is
an ARM board.

On PowerPC we use arch/powerpc/sysdev/simple_gpio.c, but
the new driver is much more generic, and is aimed to
replace the PowerPC specific one. So it is 'generic' in
this exact sense.

I also think that it is impractical to name the driver
after the particular FPGA IP codename, or even depend
on 'FPGA' word at all (as the GPIOs might be in ASIC
someday).

> There are other FPGA/CPLD GPIO modules, and most of the
> GPIOs in SOCs also match your description, but aren't
> even vaguely compatible with this specific interface.

Well, good. They don't have to use this driver. The driver
is for 'simple' GPIOs, just as the driver name states. I.e.
just a 'data' register or data + set + clr. The name
'simple', IMHO, perfectly matches the purpose of that
driver, no?

If you don't like the word 'generic' in the email subject
(the word does not appear anywhere else), I can remove it,
but I don't see why the name 'simple' doesn't work for
this driver.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
