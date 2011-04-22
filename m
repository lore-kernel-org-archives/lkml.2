Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1DVVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:16:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35430 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1DVVQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:16:54 -0400
Date: Fri, 22 Apr 2011 23:16:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk, shaohua.li@intel.com, sds@tycho.nsa.gov,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
Subject: Re: Make RCU dcache work with CONFIG_SECURITY=y
Message-ID: <20110422211649.GW16484@one.firstfloor.org>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org> <BANLkTi=kod0vH3Ybb4Fe=Sa5zvzYSmoj1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=kod0vH3Ybb4Fe=Sa5zvzYSmoj1Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 11:26:09AM -0700, Linus Torvalds wrote:
> On Thu, Apr 21, 2011 at 5:23 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > I didn't find good test suites for the security modules, so
> > there wasn't a lot of testing on this unfortunately
> > (the selinux one for LTP doesn't seem to work). Some close
> > review of these changes is needed.
> >
> > On the other hand the VFS changes itself are very straight forward
> > and the 1/1 patch is very straight forward (and a win in itself)
> >
> > The bottom line is with this patchkit a CONFIG_SECURITY=y
> > kernel has as good VFS performance as a kernel with CONFIG_SECURITY
> > disabled.
> 
> Gaah. My immediate reaction to the patch-series was "This is great, I
> was really hoping we could get all those annoying cases sorted out,
> and I'll queue them for the next merge window".
> 
> Having then actually read through the patches a bit more, I then got
> convinced that at least the first patch should probably be applied
> right away and be marked for stable, since it looks pretty damn
> obvious to me, and it might already on its own fix the performance
> regression for some configurations (although realistically I guess few
> enough people really do the "selinux=0" thing, so the big advantage is
> making easier to backport the other patches later if we don't do them
> now).

Yes I agree. The first patch is (nearly) a no-brainer and already
has significant benefits. I would like to see it in .39.

> Comments? I'd really like to see/hear feedback like "yeah, this looks
> really obviously safe" vs "yeah, looks good, but I really don't feel
> very comfortable with it" from the security people.

Especially SMACK review is needed. Or maybe selinux only for now,
already got one ack for that.

(BTW I have some doubts on the locking in smack in general, 
but that's a separate issue -- see other thread)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
