Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1I2Jqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:46:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33570 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab1I2Jqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:46:32 -0400
Date: Thu, 29 Sep 2011 10:46:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
	choice
Message-ID: <20110929094602.GH23944@n2100.arm.linux.org.uk>
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org> <1316568208-4518-2-git-send-email-sboyd@codeaurora.org> <4E83D25C.6020306@codeaurora.org> <20110929092102.GB25061@e102144-lin.cambridge.arm.com> <20110929094243.GC25061@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929094243.GC25061@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:42:43AM +0100, Will Deacon wrote:
> Bah, just took this for a spin on my Realview-PBX (Cortex-A9) platform and
> the board won't boot unless I have a hardware debugger enabled that can
> service the comms channel. This contradicts the Kconfig text which says:
> 
> 	  It does include a timeout to ensure that the system does not
> 	  totally freeze when there is nothing connected to read.
> 
> so we certainly need to fix something!

One of the problems you'll encounter is that there's places where we
don't have any timer infrastructure (eg, decompressor) and software
timing loops won't work (they'll be too slow for the lower-end CPUs
and too fast for the upper-end CPUs.)

The best fix is probably to leave that as-is, but introduce a 'default'
output entry instead - so platforms which don't have any listed will
get that instead of the ICEDDC stuff.
