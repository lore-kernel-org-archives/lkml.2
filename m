Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1H3KCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:02:52 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:31477
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab1H3KCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:02:49 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz936eK146fK1b0bM179dN1432N98dKzz1202h1082kzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQQJWE-01-30X-02
X-M-MSG: 
Date: Tue, 30 Aug 2011 12:02:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: Linux 3.1-rc4
Message-ID: <20110830100236.GA17222@gere.osrc.amd.com>
References: <CA+55aFwwtfLpmNS+Wm4DXgJsipPS8siF6Dur4rMDum7Zs=KqKw@mail.gmail.com>
 <20110830070715.GA15134@liondog.tnic>
 <1314695670.2054.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314695670.2054.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 11:14:30AM +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 09:07 +0200, Borislav Petkov wrote:
> > On Sun, Aug 28, 2011 at 09:52:43PM -0700, Linus Torvalds wrote:
> > > We're back on track on weekly -rc releases.
> > 
> > Peter,
> > 
> > I get the following lockdep splat on -rc4, it looks like load balancing
> > something.
> > 
> > [ 5183.478132] ------------[ cut here ]------------
> > [ 5183.478155] WARNING: at kernel/lockdep.c:690 __lock_acquire+0x189/0x916()
> 
> that's:
> 
> look_up_lock_class():
>                         WARN_ON_ONCE(class->name != lock->name);
> 
> That's something that really shouldn't happen and my first guess is that
> you're suffering some memory corruption.

Hmm, strange. That was one of Linus' suggestions last time I triggered
something similar in look_up_lock_class(). (Thanks Yong, I'd completely
forgotten about it). The old issue was a list corruption at the same
spot and this one looks similar except the list element is there to not
trap on the memory access but it triggers on the warning because it is
obviously a different element.

And the fact that I'd completely forgotten about it is that it hasn't
reappeared since then (v2.6.37-rc5-62-g6313e3c) which fits with the
pattern of a memory corruption.

Anyway, this is just FYI in case someone else triggers it too, I'll be
on the lookout for other strange things cooking up while the machine is
running.

Thanks.

-- 
Regards/Gruss,
Boris.

