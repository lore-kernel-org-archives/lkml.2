Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1EPRb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:31:58 -0400
Received: from kroah.org ([198.145.64.141]:57143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1EPRb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:31:57 -0400
Date: Mon, 16 May 2011 10:29:58 -0700
From: Greg KH <greg@kroah.com>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        alan@linux.intel.com
Subject: Re: [PATCH 1/2] amba pl011: workaround for uart registers lockup
Message-ID: <20110516172958.GA13011@kroah.com>
References: <1305550879-28945-1-git-send-email-shreshthakumar.sahu@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305550879-28945-1-git-send-email-shreshthakumar.sahu@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 06:31:18PM +0530, Shreshtha Kumar SAHU wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> This workaround aims to break the deadlock situation
> which raises during continuous transfer of data for long
> duration over uart with hardware flow control. It is
> observed that CTS interrupt cannot be cleared in uart
> interrupt register (ICR). Hence further transfer over
> uart gets blocked.
> 
> It is seen that during such deadlock condition ICR
> don't get cleared even on multiple write. This leads
> pass_counter to decrease and finally reach zero. This
> can be taken as trigger point to run this UART_BT_WA.
> 
> Workaround backups the register configuration, does soft
> reset of UART using BIT-0 of PRCC_K_SOFTRST_SET/CLEAR
> registers and restores the registers.
> 
> This patch also provides support for uart init and exit
> function calls if present.
> 
> Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

Please always run your patches through scripts/checkpatch.pl so we don't
end up telling you to fix up the same obvious things that this tool
would tell you needs to be fixed...

thanks,

greg k-h
