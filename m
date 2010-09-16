Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0IPRz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:55:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab0IPRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <1284659227.2275.595.camel@laptop>
References: <20100915104855.41de3ebf@lilo> <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
 <1284654451.2275.579.camel@laptop> <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
 <1284657194.2275.585.camel@laptop> <AANLkTikquj_2DE4UhTFAoDxL+1g=_BocCQJ5agrwC4NU@mail.gmail.com>
 <1284659227.2275.595.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Sep 2010 10:54:29 -0700
Message-ID: <AANLkTi=hFydeqk_ENGmqEqwqduSeN2gpjMr+VpcN38Xx@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-09-16 at 10:34 -0700, Linus Torvalds wrote:
>>
>> Of course, these days I would seriously suggest against trying to
>> optimize the kmap() case. It only matters on crap hardware these days.
>> Anybody running HIGHMEM in 2010 and thinks that it makes sense
>> deserves the pain the get. We should not complicate the kernel further
>> for it, and sane architectures will have a no-op kmap().
>
> OK, fully agreed. Someone ought to tell ARM though :-)

You know what? I don't care. If the fact that ARM is messing up means
that they will never be able to do well in the micro-server space,
that's _their_ problem.

I fought HIGHMEM tooth and nail when it appeared originally. I lost,
because we really didn't have any choice. But there is no way I'm
going to say "oh, HIGHMEM still makes sense in 2010 because the ARM
guys are now making all the same mistakes Intel did in 1992". Because
these days we _do_ have a choice.

And all the rumors are that there will be a 64-bit ARM too. So their
PAE mess will be out before, but nobody sane should really consider it
a primary issue. It will work, but it will work suboptimally.  That's
what you get when you have bad hardware design.

                       Linus
