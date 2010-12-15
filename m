Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0LOSVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:21:30 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2697 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0LOSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:21:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66747232"
Subject: Re: [PATCH 2/7] msm: Physical offset for MSM8960
From: Daniel Walker <dwalker@codeaurora.org>
To: Steve Muckle <smuckle@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4D0903EB.6080206@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1292384961-8851-3-git-send-email-stepanm@codeaurora.org>
	 <4D08BFFC.3020103@ru.mvista.com> <20101215135508.GB8682@huya.qualcomm.com>
	 <1292424054.13887.5.camel@m0nster>
	 <20101215153837.GB15817@huya.qualcomm.com>
	 <1292435728.7789.8.camel@c-dwalke-linux.qualcomm.com>
	 <4D0903EB.6080206@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 10:21:12 -0800
Message-ID: <1292437272.7789.18.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 10:07 -0800, Steve Muckle wrote:
> On 12/15/10 09:55, Daniel Walker wrote:
> > The board file is very similar, plus the ifdefs. The code differences
> > are the io and irq's .. The naming issue and the duplication can be
> 
> 8x60 and 8960 are expected to diverge over time. It is not worth it to
> try and make them common in this early stage where they are the same
> simply because a very small amount of 8960 (and 8660 for that matter)
> has been sent upstream.

My scheme should deal with that .. 

> > simplified just by combining 8960 and 8660 .. If you create two new
> > Kconfig options,
> > 
> > config MACH_MSM8660
> > 	bool
> > config MACH_MSM8960
> > 	bool
> 
> We currently use ARCH_MSM* for SoCs, and MACH_* for boards based on
> those SoCs. For this reason I think this scheme will be confusing and
> lead to machine_is_() calls everywhere.

You just need to look at this a different way. It's actually not much
different than what we currently have, it just saves us the duplication
and eliminates the naming problem .. The current version shouldn't need
machine_is_() calls so then this new way shouldn't either. You just use
the ifdef's ..

> I suggest we rename 8x60 to 8660 (SteveMo's idea actually) if the
> current naming is largely considered unacceptable.

I wouldn't say it's unacceptable, it's just a open question if there's a
better way.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

