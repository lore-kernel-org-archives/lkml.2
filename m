Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1DOIz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:55:28 -0400
Received: from 8bytes.org ([88.198.83.132]:50841 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1DOIz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:55:27 -0400
Date: Fri, 15 Apr 2011 10:55:26 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Alex Deucher <alexdeucher@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415085526.GI18463@8bytes.org>
References: <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <4DA654D6.2060103@zytor.com> <20110414085624.GC18463@8bytes.org> <BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com> <20110414210932.GG18463@8bytes.org> <1302855994.15520.158.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302855994.15520.158.camel@thor.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 10:26:34AM +0200, Michel Dänzer wrote:
> On Don, 2011-04-14 at 23:09 +0200, Joerg Roedel wrote: 
> > On Thu, Apr 14, 2011 at 10:28:43AM -0400, Alex Deucher wrote:
> > > On Thu, Apr 14, 2011 at 4:56 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > > > And this makes a difference, with this change on-top of -rc3 the box boots
> > > > fine. So there seems to be some dependency between the GART base and the GTT
> > > > base even when they are in different address spaces.
> > > >
> > > > Alex, can you comment on this?
> > > 
> > > As Dave said, they are completely different addresses spaces.  You
> > > could put the GPU aperture at 0 if you wanted (in fact we do on some
> > > chips).  Perhaps there's some strange interaction with the nb gart
> > > since the nb gart on that chipset was designed to be used for graphics
> > > and the rs780/880 can be configured to use an agp aperture.
> > > Unfortunately, I'm not that familiar with the nb gart.
> > 
> > Actually, the nb gart is part of the cpu. It is part of the cpu north
> > bridge and can translate io and cpu accesses. In fact, it is a remapper
> > of physical memory addresses.
> > 
> > The problem seems to be related to specific gpu chips. On another
> > notebook with an hd3000 card gtt and the nb gart aperture are both on
> > 0xa0000000 too but the box works fine.
> 
> Wasn't the working theory that the problem occurs if those two values
> aren't the same?

Yes it is, but this doesn't seem to be problematic on all readeon GPU
chips.

	Joerg

