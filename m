Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1DOOth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:49:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58866 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1DOOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XUTYWP7DrJkxNG27QzhupdPaO8EgAJQ4TMK/81bVZOJ7r/3/ncTFkH/LAyvxoN5ghT
         QTxRIdjPFtV9T/jwgN7Kh39h/6ByEiZs9S2McvixAUf1guRFaR/3J5hAAZXMjVqr0ubI
         9/t/cvVuvpiDmpjgF9eWa+eReneIqSFh8C4fk=
Date: Fri, 15 Apr 2011 16:49:30 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415144930.GB4883@alberich.amd.com>
References: <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
 <20110412184433.GF19819@8bytes.org>
 <20110413064609.GA18777@elte.hu>
 <20110413172147.GI19819@8bytes.org>
 <4DA5F62F.3030504@kernel.org>
 <4DA654D6.2060103@zytor.com>
 <20110414085624.GC18463@8bytes.org>
 <BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com>
 <20110414210932.GG18463@8bytes.org>
 <BANLkTimRrx-QLPWwJx37qWhtwhdC8RTpsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimRrx-QLPWwJx37qWhtwhdC8RTpsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 05:34:46PM -0400, Alex Deucher wrote:
> On Thu, Apr 14, 2011 at 5:09 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Thu, Apr 14, 2011 at 10:28:43AM -0400, Alex Deucher wrote:
> >> On Thu, Apr 14, 2011 at 4:56 AM, Joerg Roedel <joro@8bytes.org> wrote:
> >> > And this makes a difference, with this change on-top of -rc3 the box boots
> >> > fine. So there seems to be some dependency between the GART base and the GTT
> >> > base even when they are in different address spaces.
> >> >
> >> > Alex, can you comment on this?
> >>
> >> As Dave said, they are completely different addresses spaces.  You
> >> could put the GPU aperture at 0 if you wanted (in fact we do on some
> >> chips).  Perhaps there's some strange interaction with the nb gart
> >> since the nb gart on that chipset was designed to be used for graphics
> >> and the rs780/880 can be configured to use an agp aperture.
> >> Unfortunately, I'm not that familiar with the nb gart.
> >
> > Actually, the nb gart is part of the cpu. It is part of the cpu north
> > bridge and can translate io and cpu accesses. In fact, it is a remapper
> > of physical memory addresses.
> 
> I know what it's for.  In the IGP graphics chip is also part of the
> north bridge, but it may not be related at all.
> 
> >
> > The problem seems to be related to specific gpu chips. On another
> > notebook with an hd3000 card gtt and the nb gart aperture are both on
> > 0xa0000000 too but the box works fine. I havn't tested with an hd5000
> > yet. The failing notebook has an hd4200 mobility.
> 
> What exact model is the hd3000?   Is it IGP GPU or a discrete GPU?  It
> it's an IGP, it's identical to the hd4200 programming-wise.

BTW, first of all the other notebook had a different CPU (it's family
0fh and Joerg's is family 10h). So different CPUs different GARTs
different issues ;-)

(Furthermore for CPU family 0fh reporting of GartTblWalk errors is
already switched off in arch/x86/kernel/cpu/mcheck/mce.c.)


Andreas
