Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0LONoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:44:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1948 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab0LONoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:44:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66715182"
Date: Wed, 15 Dec 2010 05:44:14 -0800
From: David Brown <davidb@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH v5 5/5] msm: add SMP support for msm
Message-ID: <20101215134414.GA8682@huya.qualcomm.com>
References: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org>
 <1292302233-16194-6-git-send-email-johlstei@codeaurora.org>
 <AANLkTimnuTcv+5cWNzvV-Z=1LHsAmTojDSBJMjjOs7K+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimnuTcv+5cWNzvV-Z=1LHsAmTojDSBJMjjOs7K+@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 12:35:18PM +0000, Catalin Marinas wrote:
> On 14 December 2010 04:50, Jeff Ohlstein <johlstei@codeaurora.org> wrote:
> > +       outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
> > +       __asm__("sev");
> > +       dsb();
> 
> What's the need for the dsb() here (one before SEV maybe)?
> 
> Also, do we need to add a "memory" clobber to the SEV asm, not sure
> whether the compiler would try to reorder the code.

It doesn't seem to, but it seems to me that it would be allowed to,
so, I would think the "memory" clobber should be there.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
