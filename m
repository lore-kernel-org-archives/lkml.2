Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1ADSxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:53:06 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:31181 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1ADSxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:53:03 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OkRiTErQ8F6Y5phwa4lty
Date: Tue, 4 Jan 2011 10:52:56 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH 3/3] hvc_dcc: Simplify assembly for v6 and v7 ARM
Message-ID: <20110104185256.GD7771@atomide.com>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-4-git-send-email-sboyd@codeaurora.org>
 <alpine.LFD.2.00.1012201644110.10437@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012201644110.10437@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre <nico@fluxnic.net> [101220 13:44]:
> On Mon, 20 Dec 2010, Stephen Boyd wrote:
> 
> > The inline assembly differences for v6 vs. v7 in the hvc_dcc
> > driver are purely optimizations. On a v7 processor, an mrc with
> > the pc sets the condition codes to the 28-31 bits of the register
> > being read. It just so happens that the TX/RX full bits the DCC
> > driver is testing for are high enough in the register to be put
> > into the condition codes. On a v6 processor, this "feature" isn't
> > implemented and thus we have to do the usual read, mask, test
> > operations to check for TX/RX full.
> > 
> > Since we already test the RX/TX full bits before calling
> > __dcc_getchar() and __dcc_putchar() we don't actually need to do
> > anything special for v7 over v6. The only difference is in
> > hvc_dcc_get_chars(). We would test RX full, poll RX full, and
> > then read a character from the buffer, whereas now we will test
> > RX full, read a character from the buffer, and then test RX full
> > again for the second iteration of the loop. It doesn't seem
> > possible for the buffer to go from full to empty between testing
> > the RX full and reading a character. Therefore, replace the v7
> > versions with the v6 versions and everything works the same.
> > 
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: Daniel Walker <dwalker@codeaurora.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

Acked-by: Tony Lindgren <tony@atomide.com>
