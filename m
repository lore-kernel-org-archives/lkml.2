Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423955Ab2LGTaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:30:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2LGTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:30:23 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=ixzo9xMOGk0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=SI6hN_Grf5sA:10 a=810z4Twaj8d2Qx7Ky3sA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 7 Dec 2012 14:30:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207193019.GA31591@home.goodmis.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126025520.GC22858@thunk.org>
 <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 10:18:00AM -0800, Linus Torvalds wrote:
> 
> And that's _fine_. Once you have actual technical arguments ("I'd like to 
> re-appropriate that bit, because xyzzy") you have real and valid 
> arguments, and it would be easy to then do the sane "let's just use the 
> bit for something more worthy" thing. But even then it's nice to have the 
> knowledge about what the implications of such use would be, for chrissake!

First I want to say that I don't really give a crap about this bit, and
whether or not it's been merged or not. But I think Ric did have one
valid point:

>> I would prefer to fix the performance issue in ext4 rather than add an
>> interface that has no actual users of the actual feature - it exists
>> for applications that want to avoid an unfortunate performance hit
>> from something that we could work around.

This is similar to the preemptible big kernel lock. The BKL has been an
issue for almost everyone, and a really big one for the real-time
folks. But because it was converted into a preemtible lock, it was
dropped low on the priority list of things to get fixed. But it wasn't
until you reverted this code to kick our ass into gear to go about and fix
the issue.

How is this similar? By adding this bit, we removed incentive from a
group of developers that have the means to fix the real issue at hand
(the performance problem with ext4). Thus, it means that they have a work
around that's good enough for them, but the rest of us suffer.

Sure, they could just modify their kernel to keep this bit, but as it
wouldn't be reserved, they would have to worry about colisions in the
future. Thus the incentive to fix the problem at hand. Just like we had
the preempt BKL in the real-time patch, but it was just better to get it
fixed in mainline. Thanks to Frederic that started the work, and then Arnd
that finished it, we no longer have that nasty lock around to deal with.

You were very wise to revert the preemptible BKL, as I believe we
probably would still have BKL in the kernel if you didn't do that. Maybe
reverting this bit might do the same thing? Maybe not. It's your call.

-- Steve

