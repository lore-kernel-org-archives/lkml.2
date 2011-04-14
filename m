Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab1DNCDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:03:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60646 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab1DNCDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:03:42 -0400
Message-ID: <4DA655E7.3000904@zytor.com>
Date: Wed, 13 Apr 2011 19:03:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
In-Reply-To: <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 04:39 PM, Linus Torvalds wrote:
> 
>  - Choice #2: understand exactly _what_ goes wrong, and fix it
> analytically (ie by _understanding_ the problem, and being able to
> solve it exactly, and in a way you can argue about without having to
> resort to "magic happens").
> 
> Now, the whole analytic approach (aka "computer sciency" approach),
> where you can actually think about the problem without having any
> pesky "reality" impact the solution is obviously the one we tend to
> prefer. Sadly, it's seldom the one we can use in reality when it comes
> to things like resource allocation, since we end up starting off with
> often buggy approximations of what the actual hardware is all about
> (ie broken firmware tables).
> 
> So I'd love to know exactly why one random number works, and why
> another one doesn't. But as long as we do _not_ know the "Why" of it,
> we will have to revert.
> 

Yes.  However, even if we *do* revert (and the time is running short on
not reverting) I would like to understand this particular one, simply
because I think it may very well be a problem that is manifesting itself
in other ways on other systems.

The other thing that this has uncovered is that we already have a bunch
of complete b*llsh*t magic numbers in this path, some of which are
trivially shown to be wrong or at least completely arbitrary, so there
are more issues here :(

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
