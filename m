Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1EQSyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:54:03 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42526 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756375Ab1EQSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:54:00 -0400
X-Sasl-enc: UpspdN14Ny8LXurwbbdC0OaYkqCIdM/wb8g3KGi7viMY 1305658439
Date: Tue, 17 May 2011 11:51:33 -0700
From: Greg KH <greg@kroah.com>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        alan@linux.intel.com
Subject: Re: [PATCHv2 1/2] amba pl011: workaround for uart registers lockup
Message-ID: <20110517185133.GB9105@kroah.com>
References: <20110516172958.GA13011@kroah.com>
 <1305609617-9524-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <20110517182356.GA17703@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517182356.GA17703@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 11:23:56AM -0700, Greg KH wrote:
> On Tue, May 17, 2011 at 10:50:17AM +0530, Shreshtha Kumar SAHU wrote:
> > From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> > 
> > This workaround aims to break the deadlock situation
> > which raises during continuous transfer of data for long
> > duration over uart with hardware flow control. It is
> > observed that CTS interrupt cannot be cleared in uart
> > interrupt register (ICR). Hence further transfer over
> > uart gets blocked.
> > 
> > It is seen that during such deadlock condition ICR
> > don't get cleared even on multiple write. This leads
> > pass_counter to decrease and finally reach zero. This
> > can be taken as trigger point to run this UART_BT_WA.
> > 
> > Workaround backups the register configuration, does soft
> > reset of UART using BIT-0 of PRCC_K_SOFTRST_SET/CLEAR
> > registers and restores the registers.
> > 
> > This patch also provides support for uart init and exit
> > function calls if present.
> 
> Why?  You don't use these callbacks in this driver, so why add them?

Ok, I see them in the 2/2 patch now, thanks.

Do you still want me to take this patch through the serial tree, or will
both be going through some ARM tree?

greg k-h
