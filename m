Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1CYPaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:30:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49889 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1CYPaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EWFaslGRA48oXQDmKfLYLWnZ3jo4ZFQqflHMOFeGYhJ9YGcix9UPt5YmO77Yk/zqWj
         YwroPcMIfOpJaACRVpJsPT2jbjkv8F93d8g6ZibWluuk+QrzHyGyEa75Fmn209ELp5At
         QBgE3IfFVpkvVIKVUUKrd0Ovplkbu8Yzkvt70=
MIME-Version: 1.0
In-Reply-To: <Pine.GSO.4.62.1103250637570.6266@umail>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
	<AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	<1300868532.3522.81.camel@thor.local>
	<AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
	<Pine.GSO.4.62.1103230633160.12612@umail>
	<1300880747.16522.13.camel@thor.local>
	<AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
	<Pine.GSO.4.62.1103240628490.1156@umail>
	<AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
	<AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
	<AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com>
	<AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
	<AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
	<AANLkTim4jYfAFHkaHAWRU2uAzgRJLP1p1=5dugZgYkhS@mail.gmail.com>
	<1301039010.12159.56.camel@thor.local>
	<AANLkTik=+Vy_9_m6WQXePNn2P8c4dezOU4LSEDtj=PaU@mail.gmail.com>
	<1301040045.12159.64.camel@thor.local>
	<Pine.GSO.4.62.1103250637570.6266@umail>
Date: Fri, 25 Mar 2011 11:29:59 -0400
Message-ID: <AANLkTi==oAsR=E-6ih2kt2f4mTSDqc893=ZaSLimx3Eh@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Jerome Glisse <j.glisse@gmail.com>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/25 Ilija Hadzic <ihadzic@research.bell-labs.com>:
>
> This thread turned into much more than what its scope is and I hoped I would
> stay out of the "fight" (especially after the vocabulary got very
> "liberal"). Yet, my code (as trivial as it is) has sparked up some old
> issues and seems to be referred to over and over again, so I want to make a
> few technical points straight:
>
> * There is no way for an application to see the VBLANK events without
>  crossing into the kernel. VBLANKs are interrupts from the hardware
>  and only kernel knows them. Any userspace-only fix would be an ugly
>  hack (as Dave pointed) and maybe the application would look like it's
>  not stuck but it would not be doing the right thing no matter what you
>  do in the user space. So if I was fixing this, I figured I would do it
>  right. If anyone knows better than me and can technically prove (in
>  code, not in words) that an application can synchronize to (a correct)
>  VBLANK without calling the kernel, be my guest: submit your code and
>  evict mine. I have no problem with that, but if something breaks then,
>  it *will* be a regression.
>
> * Most comments about DDX pertained to old-kernel/new-userland
>  situation, which for most users using distros won't happen because
>  distros will make sure they have they have consistent packages.
>  Still, even that situation was taken care of in the sense that
>  it does not cause bogus errors (BTW, that comment was made and
>  was legitimate and I took care of it) nor any other "damage" to the
>  kernel. Discussing whether visual behavior in this case (a case that is
>  actually an installation/dependency problem) should be the same as in
>  old versions or still broken but masked out in appearance is a waste
>  of time and bandwidth.
>
> * Saying that "kernel was not supposed to work with more two CRTCs" is
>  just plain wrong (and probably based on superficial understanding of
>  the kernel code). I spent considerable time analyzing the kernel from
>  the driver up and the userland from the application down and found that
>  *everything* in the kernel is capable of supporting up to 32 CRTCs and
>  so is in the userland. It's only that one ioctl was stopping
>  the information flow between the userland and the kernel so I fixed it.
>  That may have been the legacy from old days when kernel didn't support
>  multiple CRTCs, but now it does. Also, there is now hardware with
>  multiple CRTCs, so kernel (and associated ioctls) should better support
>  it.

I would like to think my self as someone knowing enough about the drm,
i have writte somethings like 4 different version of the radeon kms
before converging on the one actually in the kernel. Yes you right
most of the drm core that deals with crtc can handle more than 2 this
is because most of this are new drm stuff introduced with kms. I was
taking the vblank stuff as an example as it's one of the oldest piece
of drm that was designed long ago, way before kms in time where gpu
with 2 crtc were only high end one.

> * My fix alone, does not justify introducing a new ioctl and nobody can
>  convince me that it does. In fact, being too liberal on introducing
>  new ioctls is just bad programming. Recognizing that the existing ioctl
>  has other shortcomings and coming up with a totally new ioctl with
>  many other features and then adjusting the userland to use it is a long
>  term project. My fix was a short term thing to get things that are
>  broken working.
>
> And just a few non-technical things in conclusion and a few of my own
> thoughts and views: Although I didn't mention any names so far, everyone
> smart enough reading this will know that most of my responses are a)
> directed to Michel and b) are just a repeat of what I have already said on
> the list (in response to his repeat of what was also already said). Let me
> just say that I value everyone's comments and I respect the knowledge, work
> and time effort of everyone in this group. However, in every development
> model (including the open-source) there is a point after which you have to
> move on (even if the proposed thing is not perfect) and there is someone
> whose word should be final.
>
> My understanding is that for the DRM, the final say comes from Dave. So,
> fine, there were imperfections in my proposed modification to the ioctl,
> there was one comment that I (mistakenly) oversaw and that Michel found
> utterly important (although I still think that it wasn't that much of a big
> deal), but if Dave accepted the original change, that implicitly meant that
> he took into accounts the discussion, follow-up modifications and rebuttals
> and that the issue should be behind us. Continuing to insist after that
> point is just plain destructive (and could be in part the reason why DRM,
> besides the lack of resources, is behind closed-source drivers).
>
> And there is another point that Dave made that I fully support. To all of
> you, I am a newcomer, and a plain garden-variety user who instead of whining
> on Bugzilla and hoping that some hacker out there will show some "mercy",
> actually stepped up to fix the problem (and to be allowed to do that, I had
> to convince a few higher-ups that this would actually be in the interest of
> those who write my paycheck). Some of you have shown appreciation for that
> (thanks!), but some of you have seen it as an opportunity to publicly prove
> that you are smarter than me (for which I frankly don't care, as long as it
> does not impact the progress of the development, but in this case it did).
>
> I may be new to Linux/DRM "club", but I am not new to the large system
> development (including a wide variety of kernels and other very complex
> subsystems). Now if I can get my own (very reasonable, technically correct,
> generally well written, and useful for the community) fixes into open-source
> without sparking up major fights, then in my day-job, I have a strong case
> to present to a bunch of MBAs in three-piece suits that we should be basing
> more of our products on open-source code. That alone, in the long run helps
> the community, which is, I presume, a common interest of all of us.
>
> 'nuff said
>
> -- Ilija
>

Cheers,
Jerome
