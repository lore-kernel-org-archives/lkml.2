Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0J3Utc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 16:49:32 -0400
Received: from claw.goop.org ([74.207.240.146]:36591 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab0J3Ut3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 16:49:29 -0400
Message-ID: <4CCC84D8.6080005@goop.org>
Date: Sat, 30 Oct 2010 13:49:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>,
        Nitin Gupta <nitingupta910@gmail.com>
Subject: Re: Ping? RE: [GIT PULL] mm/vfs/fs:cleancache for 2.6.37 merge window
References: <ec76a6ed-a1dc-4e8b-a4ac-1e72ab367d0f@default>	<7b34b3ea-9436-4077-a35e-a5eaabd59813@default> <20101030120632.40345d0d.akpm@linux-foundation.org>
In-Reply-To: <20101030120632.40345d0d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/30/2010 12:06 PM, Andrew Morton wrote:
> On Wed, 27 Oct 2010 11:37:47 -0700 (PDT) Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>
>> Ping?  I hope you are still considering this.  If not or if
>> there are any questions I can answer, please let me know.
> What's happened here is that the patchset has gone through its
> iterations and a few people have commented and then after a while,
> nobody had anything to say about the code so nobody said anything more.
>
> But silence doesn't mean acceptance - it just means that nobody had
> anything to say.
>
> I think I looked at the earlier iterations, tried to understand the
> point behind it all, made a few code suggestions and eventually tuned
> out.  At that time (and hence at this time) I just cannot explain to
> myself why we would want to merge this code.
>
> All new code is a cost/benefit decision.  The costs are pretty well
> known: larger codebase, more code for us and our "customers" to
> maintain and support, etc.  That the code pokes around in vfs and
> various filesystems does increase those costs a little.
>
> But the extent of the benefits to our users aren't obvious to me.  The
> code is still xen-specific, I believe?  If so, that immediately reduces
> the benefit side by a large amount simply because of the reduced
> audience.
>
> We did spend some time trying to get this wired up to zram so that the
> feature would be potentially useful to *all* users, thereby setting the
> usefulness multiplier back to 1.0.  But I don't recall that anything
> came of this?

Nitin was definitely working on this and made some constructive comments
as a result, but I don't know if there's any completed/usable code or not.

> I also don't know how useful the code is to its intended
> micro-audience: xen users!

The benefit is that it allows memory to be much more fluidly assigned
between domains as needed, rather than having to statically allocate big
chunks of memory.  The result is that its possible to provision domains
with much smaller amounts of memory while still reducing the number of
real pagefault IOs.  Dan's numbers are certainly very interesting (Dan,
perhaps you can repost those results).

However, I don't think it has been widely deployed yet, since most users
are using upstream/distro kernels.

> So can we please revisit all this from the top level?  Jeremy, your
> input would be valuable.

OK, I'll need to get myself up to speed on the issues again.  Will you
be about in Boston next week?

>   Christoph, I recall that you had technical
> objections - can you please repeat those?

I think (and I don't want to misrepresent or minimize Christoph's
concerns here) the most acute one were the need for a one-line addition
to each filesystem which wants to participate.

> It's the best I can do to kick this along, sorry.

Thanks,
    J

