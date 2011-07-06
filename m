Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1GFGlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:41:21 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:58384 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695Ab1GFGlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:41:20 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/yWKkKCRPF0Nhqyn70lby
Date: Tue, 5 Jul 2011 23:41:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
        Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] OMAP: hwmod: add kernel cmdline flag to avoid
 resetting IP blocks during init
Message-ID: <20110706064116.GH5783@atomide.com>
References: <20110703010204.19046.85186.stgit@dusk>
 <20110703010206.19046.85293.stgit@dusk>
 <20110704085503.GQ23145@atomide.com>
 <alpine.DEB.2.00.1107051936250.4217@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107051936250.4217@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [110705 18:37]:
> cc'ing Aaro
> 
> On Mon, 4 Jul 2011, Tony Lindgren wrote:
> 
> > Also related is the gptimer12 on secure omaps as reported by Aaro.
> 
> This problem is actually worse.  In this case it's not just preventing 
> reset; we must prevent the kernel from using the device at all. My 
> understanding is also that it's the X-Loader or bootloader -- or more 
> broadly, secure mode code -- that actually chooses which devices are 
> protected in this way.  In other words, we can't make any automatic 
> decisions that are based on knowing that a chip is a high-security chip -- 
> it will need to be defined by the board file :-(
> 
> For this case, we probably need some board file function to tell the hwmod 
> code to disregard a device completely, to tell the kernel to pretend that 
> the device does not exist.

Yeah that should be done in a generic way. Some shared devices can also
be used by a coprocessor like the DSP instead.

So basically we want to tell the following from the board file or board
specific .dts file:

- Device is being used on the board and can be reset and configured.
  This is the usual case.

- Device is being used on the board but can't be reset. This is the
  case for booting Linux from other operating systems initially where
  you want to keep the LCD on for debug console.

- Device is not being used on the board but can be reset for decent PM.
  This is often needed in cases where the bootloader just enables all the
  clocks.

- Device is reserved by secure mode or a coprocessor. In this case
  the device can't be reset.

So I guess that makes the flags noreset, disabled and unavailable?

For the devices with no special flags we would then reset the device.

Regards,

Tony
