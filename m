Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1I2SEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:04:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53815 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1I2SE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:04:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6484"; a="123525581"
Date: Thu, 29 Sep 2011 11:04:28 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
 choice
Message-ID: <20110929180428.GA8125@huya.qualcomm.com>
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org>
 <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
 <4E83D25C.6020306@codeaurora.org>
 <20110929092102.GB25061@e102144-lin.cambridge.arm.com>
 <20110929094243.GC25061@e102144-lin.cambridge.arm.com>
 <20110929094602.GH23944@n2100.arm.linux.org.uk>
 <20110929103939.GD25061@e102144-lin.cambridge.arm.com>
 <4E84A962.9030806@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E84A962.9030806@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:22:42AM -0700, Stephen Boyd wrote:
> >> One of the problems you'll encounter is that there's places where we
> >> don't have any timer infrastructure (eg, decompressor) and software
> >> timing loops won't work (they'll be too slow for the lower-end CPUs
> >> and too fast for the upper-end CPUs.)
> > Agreed, software timing loops are the only option and it's impossible to get
> > them right everywhere. I think the Kconfig help text should be updated so
> > that the timeout paragraph is removed.
> 
> Yes if you wait a long time the timeout for each character will expire
> and the execution will continue.

Wouldn't it be better to detect the first timeout and then stop trying
to write to the DCC?

But, do we really want fancy auto-detection stuff in DEBUG_LL?  A
timeout might make sense for a DCC console, but not here.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
