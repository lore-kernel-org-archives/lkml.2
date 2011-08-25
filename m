Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1HYRQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:16:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38893 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588Ab1HYRQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:16:12 -0400
Date: Thu, 25 Aug 2011 18:15:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v2 03/43] arm: Use set_current_blocked() and
 block_sigmask()
Message-ID: <20110825171556.GH27143@e102144-lin.cambridge.arm.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
 <1313772419-21951-4-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313772419-21951-4-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Fri, Aug 19, 2011 at 05:46:19PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check for shared signals we're about to block.
> 
> Also, use the new helper function block_sigmask() which centralises
> the code for updating current->blocked after successfully delivering a
> signal and reduces the amount of duplicate code across
> architectures. In the past some architectures got this code wrong, so
> using this helper function should stop that from happening again.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: Dave Martin <dave.martin@linaro.org>
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
> ---
> 
> v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
> for adding sigmask to current->blocked" so they need to go through the
> same tree but this patch would benefit from some maintainer ACK's.
> 
> Will, I dropped your Acked-by because I felt this patch changed quite
> dramatically since v1 and warrants another review. I hope that's OK.

Ok. Looks like the only change from v1 is calling block_sigmask. which does
what was previously done inline (in v1).

So you can keep my ack if you like!

Will
