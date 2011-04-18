Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1DRIG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:06:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44676 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1DRIGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pE2H+PsKyF/SH3l7peMcImUAw6fjUT6MZJVfi5Pl4N+jybmk+JkAU6ycI/LiYOTK6j
         TZE1pFQWDNH0NeFrVRgV7zPTluNvyV0D94UFBuC1bGsEzGK2KawTBVmLh6uyjJaRSfja
         kd7r5v8g4Yn9cYHygM3yI0KHBJaEjKdoJNoGI=
Date: Mon, 18 Apr 2011 10:06:07 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V14 3/4] ptp: Added a clock driver for the IXP46x.
Message-ID: <20110418080606.GA3809@riccoc20.at.omicron.at>
References: <cover.1303107532.git.richard.cochran@omicron.at>
 <dbee2487a57fd7f41e4efbbd2ddfb1313b8d71bc.1303107532.git.richard.cochran@omicron.at>
 <201104180856.04186.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104180856.04186.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 08:56:03AM +0200, Arnd Bergmann wrote:
> On Monday 18 April 2011, Richard Cochran wrote:
> > +
> > +       lo = __raw_readl(&regs->channel[ch].src_uuid_lo);
> > +       hi = __raw_readl(&regs->channel[ch].src_uuid_hi);
> > +
> 
> I guess you should use readl(), not __raw_readl() here. The __raw_* functions
> are not meant for device drivers.

Krzysztof had a different opinion about this.

    https://lkml.org/lkml/2011/1/8/67

Anyway, it is his driver, and I just followed what he does elsewhere
in the driver. It make sense to me to keep the driver consistent.
Maybe we should make the change throughout?

Thanks,
Richard
