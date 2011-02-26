Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1BZR6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 12:58:55 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12554 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1BZR6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 12:58:54 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6269"; a="76878216"
From: David Brown <davidb@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] msm: scm: Fix improper register assignment
In-Reply-To: <20110226084736.GB3640@n2100.arm.linux.org.uk> (Russell King's
	message of "Sat, 26 Feb 2011 08:47:36 +0000")
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	<1298573085-23217-3-git-send-email-sboyd@codeaurora.org>
	<1298640219.958.74.camel@e102144-lin.cambridge.arm.com>
	<4D688AF1.1090607@codeaurora.org>
	<20110226084736.GB3640@n2100.arm.linux.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110226:will.deacon@arm.com::pGkW8AA05bATREla:0000000000000000000000000000000000000000000Wwk
X-Hashcash: 1:20:110226:skannan@codeaurora.org::rFyH/Jgp9WgBdzLl:0000000000000000000000000000000000000001in8
X-Hashcash: 1:20:110226:linux-arm-msm@vger.kernel.org::HIEPPpsPuySw8pQ/:000000000000000000000000000000002Rd2
X-Hashcash: 1:20:110226:linux-arm-kernel@lists.infradead.org::8ZJ0h9l1zy/gMixk:00000000000000000000000004P7c
X-Hashcash: 1:20:110226:linux@arm.linux.org.uk::fQzLAgRnmOMWcTRV:0000000000000000000000000000000000000004egs
X-Hashcash: 1:20:110226:sboyd@codeaurora.org::jMIlRAYlBlDHtE0+:000000000000000000000000000000000000000008RRM
X-Hashcash: 1:20:110226:linux-kernel@vger.kernel.org::Ev0WicZcryAcQx0T:000000000000000000000000000000000CV3C
Date: Sat, 26 Feb 2011 09:58:49 -0800
Message-ID: <8yazkpi3cfa.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26 2011, Russell King - ARM Linux wrote:

> On Fri, Feb 25, 2011 at 09:09:05PM -0800, Saravana Kannan wrote:
>> Yeah, Stephen and I spent quite a bit of time discussing this and  
>> experimenting to figure out what the heck GCC was doing. But it kept  
>> optimizing the fake code we put in trying to force GCC to use a specific  
>> register.
>
> One way to look at it is that if you specify a value for r0, assign it,
> and then call a function, how do you expect the r0 value to be preserved?
> r0 will be corrupted by the called function as its used to pass arg0 and
> the return value.

> I'm surprised the compiler didn't spit out an error.

The gcc docs say:

   * Local register variables in specific registers do not reserve the
     registers, except at the point where they are used as input or
     output operands in an `asm' statement and the `asm' statement
     itself is not deleted.  The compiler's data flow analysis is
     capable of determining where the specified registers contain live
     values, and where they are available for other uses.  Stores into
     local register variables may be deleted when they appear to be
     dead according to dataflow analysis.  References to local register
     variables may be deleted or moved or simplified.

which would suggest that it should at least detect that it can't keep
the value in r0.  What it seems to do is detect that the value can't be
in the register, so it never bothers putting it there in the first
place.

In any case, fortunately it works with the fix.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
