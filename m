Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1BZIsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 03:48:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54531 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1BZIsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 03:48:11 -0500
Date: Sat, 26 Feb 2011 08:47:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] msm: scm: Fix improper register assignment
Message-ID: <20110226084736.GB3640@n2100.arm.linux.org.uk>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-3-git-send-email-sboyd@codeaurora.org> <1298640219.958.74.camel@e102144-lin.cambridge.arm.com> <4D688AF1.1090607@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D688AF1.1090607@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 09:09:05PM -0800, Saravana Kannan wrote:
> Yeah, Stephen and I spent quite a bit of time discussing this and  
> experimenting to figure out what the heck GCC was doing. But it kept  
> optimizing the fake code we put in trying to force GCC to use a specific  
> register.

One way to look at it is that if you specify a value for r0, assign it,
and then call a function, how do you expect the r0 value to be preserved?
r0 will be corrupted by the called function as its used to pass arg0 and
the return value.

I'm surprised the compiler didn't spit out an error.
