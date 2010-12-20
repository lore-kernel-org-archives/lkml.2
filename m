Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0LTSIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:08:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22154 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0LTSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:08:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67371084"
Subject: Re: [PATCH] hvc_dcc: Simplify assembly for v6 and v7 ARM
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
References: <20101201192856.GA731@suse.de>
	 <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 09:51:01 -0800
Message-ID: <1292867461.27552.15.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 21:16 -0800, Stephen Boyd wrote:
> The inline assembly differences for v6 vs. v7 in the hvc_dcc
> driver are purely optimizations. On a v7 processor, an mrc with
> the pc sets the condition codes to the 28-31 bits of the register
> being read. It just so happens that the TX/RX full bits the DCC
> driver is testing for are high enough in the register to be put
> into the condition codes. On a v6 processor, this "feature" isn't
> implemented and thus we have to do the usual read, mask, test
> operations to check for TX/RX full.
> 
> Since we already test the RX/TX full bits before calling
> __dcc_getchar() and __dcc_putchar() we don't actually need to do
> anything special for v7 over v6. The only difference is in
> hvc_dcc_get_chars(). We would test RX full, poll RX full, and
> then read a character from the buffer, whereas now we will test
> RX full, read a character from the buffer, and then test RX full
> again for the second iteration of the loop. It doesn't seem
> possible for the buffer to go from full to empty between testing
> the RX full and reading a character. Therefore, replace the v7
> versions with the v6 versions and everything works the same.
> 
> While we're here, cleanup the for loops a bit and mark the inline
> assembly as volatile. Not marking it volatile causes GCC to cache
> the results of the status and RX buffer registers causing
> lockups.

I would expect to see three patches. One that adds volatile, which
appears to be a good fix. Another patch that changes the assembly lines,
and another that does the clean up. The last two are more controversial
ones.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


