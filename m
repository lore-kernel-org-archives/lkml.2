Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966221Ab2DLWCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:02:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14324 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022Ab2DLWCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:02:16 -0400
Date: Fri, 13 Apr 2012 00:02:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
In-Reply-To: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204122353210.7553@swampdragon.chaosbits.net>
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com> <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com> <20120412011313.GA23764@kroah.com>
 <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com> <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
 <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-166988466-1334268135=:7553"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-166988466-1334268135=:7553
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Apr 2012, Felipe Contreras wrote:

> On Thu, Apr 12, 2012 at 10:05 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, Apr 12, 2012 at 9:49 AM, Felipe Contreras
> > <felipe.contreras@gmail.com> wrote:
> >>>
> >>> A revert is the same as a patch.  It needs to be in Linus's tree before
> >>> I can add it to the stable releases.
> >>
> >> Right, because otherwise people's systems would actually work.
> >
> > There are rules for a damn good reason.
> >
> > The rule for -stable is that the changes *have* to be in upstream, for
> > a very simple reason: otherwise bugs get re-introduced.
> >
> > If -stable starts revertign things that aren't reverted up-stream,
> > what do you think happens to the *next* kernel version?
> 
> Which is why nobody is trying to change the rules regarding that.
> 
> And your same argument applies to the all the thousands of commits on
> the next kernel version; what would happen on the next kernel version?
> 
> The relevant patch, like the thousands of patches in v3.4-rc*, did not
> exist in v3.3, so if you add one on v3.3.1, and remove it on v3.3.2
> would be *exactly* the same as if you had not added it at all to the
> stable series.
> 
> > I don't think you realize how well kernel development has worked over
> > the last few years. And the stable rules are part of it.
> 
> I do understand how well the development works, which is why I often
> use it as an example and guideline, but that doesn't mean it's
> perfect.
> 
> > So stop complaining. Reverts really *are* just patches, Greg is 100%
> > right, and you are simply wrong.
> 
> I could argue in favor of exceptions, but I don't think you realize
> the fact that this change does not affect your tree *at all*. Adding
> and removing a patch in the stable tree is a no-op.
> 
> > And the revert is now apparently in John's tree, and will make it to
> > David and then me shortly. It will get reverted in stable too once
> > that happens. In the meantime, your complaints are  to Greg only shows
> > that you don't understand why the rules exist, and the fact that you
> > *continue* to complain just makes you look stupid.
> 
> Is that going to happen before Friday? If not, then v3.3.2 will still
> be broken *for no reason*.
> 
> 

Ok, -stable got broken because a bad patch was backported from mainline to 
stable - obviously that's not good.

But, just reverting that broken patch from stable is *not* good enough. 
Then we still have a broken mainline.

The rule that only commits which are in mainline get applied to -stable 
makes really, Really, REALLY good sense. It helps ensure that we don't 
miss fixes going forward.

Imagine that bad patch xyz got added to mainline and backported to stable 
and that the only people that get bitten by it are conservative types that 
only run -stable kernels. Then we revert the patch from stable since it 
broke stuff and now everyone are happy - but *mainline is still broken* 
and there's noone pushing for the problem to get fixed in mainline since 
noone affected by the problem run that kernel :-(

By insisting that only patches in mainline get backported to -stable we 
ensure that both mainline and stable get fixed (and thus also the *next* 
stable kernel that'll be cut from mainline in the future).

Yes it's a pain that -stable has to suffer a broken commit for a while - 
but sometimes that's just the little pain you have to accept. The greater 
good is that with the current rules both mainline, current -stable and 
future -stable will get fixed.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-166988466-1334268135=:7553--
