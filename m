Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2LJVmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:42:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7673 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2LJVmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:42:36 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F1vn84g2v5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GbT8ctTW91IA:10 a=LyTzgS8Sqahkuym6fv4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355175755.17101.263.camel@gandalf.local.home>
Subject: Re: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 16:42:35 -0500
In-Reply-To: <CA+55aFx=x9OzUvD+x+tUBxNN8EWRHEo7UuMx8OYBdyG3W+AcUw@mail.gmail.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
	 <1355165264.17101.233.camel@gandalf.local.home>
	 <20121210190247.GA32119@kroah.com>
	 <1355166920.17101.239.camel@gandalf.local.home>
	 <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
	 <1355172274.17101.250.camel@gandalf.local.home>
	 <CA+55aFx=x9OzUvD+x+tUBxNN8EWRHEo7UuMx8OYBdyG3W+AcUw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 13:08 -0800, Linus Torvalds wrote:

> I would almost suggest you make both my base tree and the stable tree
> be remotes, instead of necessarily mirroring my tree and then putting
> the stable tree on top of that. I think it's confusing to have a
> mirror but than in that same tree have an extra (non-mirror) remote,
> it sounds more logical to me to have two separate remotes.

I could make them both remotes. The "mirror" and fetching is more
historical than anything. I use to only have a clone of your tree, and
then when I started maintaining the stable-rt tree, I created the stable
mirror as well. My workflow with git changed between the two creations,
and what I have currently shows that.

> 
> But yeah, you should always just be able to recreate things since
> whatever you do your alternates will never have any extra work in
> them, so you could just continue with your existing setup even though
> it sounds a bit iffy.

I may just keep my current setup. I'm now thinking that this breakage
was a side effect of a previous breakage due to the brown out I had a
while back. This is the same box that corrupted my linus.git tree that I
eventually just deleted and recreated. As the cron jobs that update the
repo (and the brown out, which caused my machine to reboot, happened
during the cron job), it could have affected my stable.git repo too.

This has been like this for a week or two, when I first noticed the
missing tags. I was just busy doing other things to ask about it.

Perhaps this has nothing to do with chained alternates and git gc going
crazy. It could have just been my linus.git tree getting corrupted, and
then the git gc run on my stable.git tree shortly after, and corrupting
that too. I don't reference the stable.git tree as often as I reference
the linus.git tree, thus, I didn't put the two corruptions together.

-- Steve


