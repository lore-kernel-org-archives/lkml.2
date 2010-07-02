Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0GBJ6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:58:21 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37009 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0GBJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:58:18 -0400
Date: Fri, 2 Jul 2010 11:58:15 +0200
From: Luc Verhaegen <libv@skynet.be>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source
	kernel component
Message-ID: <20100702095815.GA6802@skynet.be>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 08:10:40AM +1000, Dave Airlie wrote:
> Now this is just my opinion as maintainer of the drm, and doesn't
> reflect anyone or any official policy, I've also no idea if Linus
> agrees or not.
> 
> We are going to start to see a number of companies in the embedded
> space submitting 3D drivers for mobile devices to the kernel. I'd like
> to clarify my position once so they don't all come asking the same
> questions.
> 
> If you aren't going to create an open userspace driver (either MIT or
> LGPL) then don't waste time submitting a kernel driver to me.
> 
> My reasons are as follows, the thing is you can probably excuse some
> of these on a point by point basis, but you need to justify why closed
> userspace on all points.
> 
> a) licensing, Alan Cox pointed this out before, if you wrote a GPL
> kernel driver, then wrote a closed userspace on top, you open up a
> while world of derived work issues. Can the userspace operate on a
> non-GPL kernel without major modifications etc. This is a can of worms
> I'd rather not enter into, and there are a few workarounds.

Yes, this a mess indeed.

But i fear that this a mess that cannot be fixed, in its entirety, in a single shot.  

Qualcomm making this code available already clearly shows the will and determination of 
some people inside qualcomm to do The Right Thing. 

This is Qualcomms first big step on the graphics side, where IP is always amongst the 
heaviest. I am certain that Qualcomm wants to go further, but since Qualcomm most 
likely licenses some parts of their graphics, Qualcomm can only open up those bits that 
they truly own, and then use mainly market/sales-volume driven pressure to get the 
original IP owner to play along.

You should also take into account who Jordan is. He is one of the guys who worked the 
Geode before AMD decided to drop that, which is when he got hired by Qualcomm. He worked on 
both the graphics drivers and on (then still) LinuxBIOS. I know that redhat has no 
intention of going near coreboot, but in my world one cannot become more free, hardware 
wise, than supporting coreboot. This gives me very good hopes that this is a serious 
attempt by qualcomm to go somewhere, and that this is not some lame attempt to grab 
marketing attention.

Now that you slammed the door on these guys (and on others in the process), what do you 
think the response would be? Where will this get us to in the end?

The licensing should get sorted, and that is of course something for Qualcomm to do, 
or prove that it has been sorted already.

> b) verifying the sanity of the userspace API.
> 1. Security: GPUs can do a lot of damage if left at home alone, since
> mostly you are submitting command streams unverified into the GPU and
> won't tell us what they mean, there is little way we can work out if
> the GPU is going to over-write my passwd file to get 5 fps more in
> quake. Now newer GPUs have at least started having MMUs, but again
> we've no idea if that is the only way they work without docs or a lot
> of trust.

This makes me wonder: Why do you even care?

If redhat was working with qualcomm, you would not have taken this stance here at all.

Since redhat is then not working with qualcomm, why is this then your responsibility?

Or is denouncing responsibility exactly the reason for your mail here?

If so, why couldn't you have stated "please guys, have fun with what you are doing, but 
i will not be responsible for it" in a different way.

What you achieved now is that people will stop bothering with even freeing this, 
putting us even further back.

But i fully understand where you are coming from: redhat only wants to seriously back 
the server market, so free software graphics on arm based SOCs probably should not be 
encouraged too much. As per usual, big statements are then more important than actual 
free software advancement.

> 2. General API suitability and versioning. How do we check that API is
> sane wrt to userspace, if we can't verify the userspace. What happens
> if the API has lots of 32/64 compat issues or things like that, and
> when we fix them the binary userspace breaks? How do we know, how do
> we test etc. What happens if a security issue forces us to break the
> userspace API? how do we fix the userspace driver and test to confirm?
> 
> c) supplying docs in lieu of an open userspace
> If you were to fully document the GPU so we could verify the
> security/api aspects it leaves us in the position of writing our own
> driver. Now writing that driver on top of the current kernel driver
> would probably limit any innovation, and most people would want to
> write a new kernel driver from scratch. Now we end up with two drivers
> fighting, how do we pick which one to load at boot? can we ever do a
> generic distro kernel for that device (assuming ARM ever solves that
> issue).

I think that by now you should have realized that this is not how it works for 
things as complex as graphics drivers. If, for instance, you hadn't been given a 
wildcard by your employer, you would never have gone close to AMD hw unless for some 
spare time poking and occasional bugfixing.

Also, before you throw this up: for nouveau, documentation would take part of the fun, 
the attraction and excitement, away. Provide docs, and then only a few very industrious 
people will remain, and they will also get weary after a while, or they get hired by 
someone to continue their work, bringing us right back to the corporate world. 

Now, it is interesting how you now are demanding documentation. When did recent and 
relevant hw documentation happen for ATI? This pretty much died together when the 
ATI<->SuSE relationship died, as the cooperation of SuSE and AMD is how documentation 
was forced out of ATI in the first place, and ATI more and more found ways to get rid 
of this responsibility, or overhead as bridgman would most likely name it.

I think it even should be possible to find statements of you and/or alex, and 
definitely bridgman, where it is claimed that for ATI, "the code is the documentation".

If you are backing this reasoning for ATI, what is wrong with this code being the 
documentation for Qualcomm?

This point about documentation at least does not seem very credible coming from you, 
with your history, especially with respect to the ATI story.

> I've also noticed a trend to just reinvent the whole wheel instead of
> writing a drm/kms driver and having that as the API, again maintainer
> nightmares are made of this.

Heh, in some of these cases, not having looked at this code in detail yet, such code 
predates kms, and drm might not have provided what was needed. Not wanting to 
completely diminish the responsibility of qualcomm (or the other companies who are 
working or are forced to work like this), you might want to think about providing 
stable and fitting infrastructure, not just stating that something is how _you_ are 
doing it and declaring that the law.

Next to that, the IP heavy part that cannot be released (yet?) might be some blob that 
is used on both linux, windows, ximbian, etc. The concept of talking to some os 
independent blob through some painful and ever-shifting layer is not that alien even to 
you, with your staunch defending of ATIs AtomBIOS over more direct modesetting.

Also, from where i sit, you complaining about people reinventing the wheel does bring 
me some bitter amusement.

As a conclusion: With you having sent this mail, guess what the guys at qualcomm, and 
most likely imagination technologies and ARM as well (i think we can already discount 
nvidia -- they are far too adept at producing solid closed source drivers -- to 
desktop users satisfaction too), will do next?

We already squandered the free software desktop (on x86), and part of the 
responsibility for that is with the graphics hw support (and the radeon versus radeonhd 
story shows nicely how to go about squandering such things). What i see here is that 
you clearly want to go down a similar street with the now blossoming ARM market.

Thanks alot,

Luc Verhaegen.
