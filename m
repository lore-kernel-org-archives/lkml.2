Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424680Ab2LGWLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:11:25 -0500
Received: from sandeen.net ([63.231.237.45]:41451 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2LGWLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:11:21 -0500
Message-ID: <50C2674F.1060305@sandeen.net>
Date: Fri, 07 Dec 2012 16:01:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com> <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org> <20121207193019.GA31591@home.goodmis.org> <20121207211440.GD29435@thunk.org>
In-Reply-To: <20121207211440.GD29435@thunk.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/12 3:14 PM, Theodore Ts'o wrote:
> On Fri, Dec 07, 2012 at 02:30:19PM -0500, Steven Rostedt wrote:
>> How is this similar? By adding this bit, we removed incentive from a
>> group of developers that have the means to fix the real issue at hand
>> (the performance problem with ext4). Thus, it means that they have a work
>> around that's good enough for them, but the rest of us suffer.
> 
> That assumes that there **is** a way to claw back the performance
> loss, and Chris Mason has demonstrated the performance hit exists with
> xfs as well (950 MB/s vs. 400 MB/s; that's more than a factor of two).

But he has not demonstrated that it can't be improved in XFS; I don't
think that anyone in the XFS community has even begun to look at
whether it can be improved ...

> Sometimes, you have to make the engineering tradeoffs.  That's why
> we're engineers, for goodness sakes.  Sometimes, it's just not
> possible to square the circle.

... so this strikes me as a bit premature.

> I don't believe that the technique of forcing people who need that
> performance to suffer in order to induce them to try to engineer a
> solution which may or may not exist is really the best or fairest way
> to go about things.

Have we exhausted efforts to improve ext4 as well?  Have we even identified
the performance bottlenecks yet via profiling?

What this seems to be is behavior nobody has asked for (expose
other users' stale data) in the name of solving a performance problem
(fine-grained conversion of unwritten extents comes at a non-negligible cost).

-Eric

> 					- Ted

