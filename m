Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1B0LKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 06:10:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60661 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab1B0LKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 06:10:45 -0500
Subject: Re: [PATCH 1/4] msm: scm: Mark inline asm as volatile
From: Will Deacon <will.deacon@arm.com>
To: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <8yapqqe3bs3.fsf@huya.qualcomm.com>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	 <1298573085-23217-2-git-send-email-sboyd@codeaurora.org>
	 <1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
	 <8yapqqe3bs3.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 11:10:33 +0000
Message-ID: <1298805034.4626.4.camel@jazzbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-26 at 18:12 +0000, David Brown wrote:
> On Fri, Feb 25 2011, Will Deacon wrote:

> > These asm blocks all have sensible looking output constraints. Why
> > do they need to be marked volatile?
> 
> Without the volatile, the compiler is free to assume the only side
> effects of the asm are to modify the output registers.  The volatile is
> needed to indicate to the compiler that the asm has other side effects.

As far as I know, volatile asm does two things:

(1) It stops the compiler from reordering the asm block with respect to
other volatile statements.

(2) It prevents the compiler from optimising the block away when
dataflow analysis indicates it's not required.

If side-effects need to be indicated, won't a memory clobber do the
trick?

Will

