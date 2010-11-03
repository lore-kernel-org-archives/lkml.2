Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0KCR5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:57:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0KCR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:57:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6156"; a="60501354"
Subject: Re: [PATCHv2 1/3] ARM: Translate delay.S into (mostly) C
From: Daniel Walker <dwalker@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
In-Reply-To: <1288300770-18350-2-git-send-email-sboyd@codeaurora.org>
References: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>
	 <1288300770-18350-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 10:57:34 -0700
Message-ID: <1288807054.16859.2.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 14:19 -0700, Stephen Boyd wrote:
> We want to allow machines to override the __delay() implementation
> at runtime so they can use a timer based __delay() routine. It's
> easier to do this using C, so let's write udelay and friends in C.
> 
> We lose the #if 0 code, which according to Russell is used "to
> make the delay loop more stable and predictable on older CPUs"
> (see http://article.gmane.org/gmane.linux.kernel/888867 for more
> info). We shouldn't be too worried though, since we'll soon add
> functionality allowing a machine to set the __delay() loop
> themselves, thus allowing machines to resurrect the commented out
> code should they need it.
> 
> Nico expressed concern that fixed lpj cmdlines will break due to
> compiler optimizations. That doesn't seem to be the case since
> before and after this patch I get the same lpj value when running
> my CPU at 19.2 MHz. That should be sufficiently slow enough to
> cover any machine running Linux.

Nico, are you ready to sign off on this?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

