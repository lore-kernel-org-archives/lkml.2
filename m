Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1DVS0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:26:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679Ab1DVS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Apr 2011 11:26:09 -0700
Message-ID: <BANLkTi=kod0vH3Ybb4Fe=Sa5zvzYSmoj1Q@mail.gmail.com>
Subject: Re: Make RCU dcache work with CONFIG_SECURITY=y
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 5:23 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> I didn't find good test suites for the security modules, so
> there wasn't a lot of testing on this unfortunately
> (the selinux one for LTP doesn't seem to work). Some close
> review of these changes is needed.
>
> On the other hand the VFS changes itself are very straight forward
> and the 1/1 patch is very straight forward (and a win in itself)
>
> The bottom line is with this patchkit a CONFIG_SECURITY=y
> kernel has as good VFS performance as a kernel with CONFIG_SECURITY
> disabled.

Gaah. My immediate reaction to the patch-series was "This is great, I
was really hoping we could get all those annoying cases sorted out,
and I'll queue them for the next merge window".

Having then actually read through the patches a bit more, I then got
convinced that at least the first patch should probably be applied
right away and be marked for stable, since it looks pretty damn
obvious to me, and it might already on its own fix the performance
regression for some configurations (although realistically I guess few
enough people really do the "selinux=0" thing, so the big advantage is
making easier to backport the other patches later if we don't do them
now).

And now I'm vacillating about the two later patches too. They look
fine to me, but I really have _zero_ familiarity with selinux and
smack internals, so unlike the first patch, I can't go "that looks
like the obviously right thing, and it clearly catches all the RCU
cases".

The "we can't use all the nifty RCU pathwalk in the config that most
distros ship by default" is clearly a performance regression, and has
meant that it's not been really showing its real advantages for most
people. So in that sense, it's a regression fix and thus valid even
though we're pretty late in the -rc series.

But at the same time, it's also a bit scary.

Comments? I'd really like to see/hear feedback like "yeah, this looks
really obviously safe" vs "yeah, looks good, but I really don't feel
very comfortable with it" from the security people.

                       Linus
