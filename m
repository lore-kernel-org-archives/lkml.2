Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1DNVJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:09:35 -0400
Received: from 8bytes.org ([88.198.83.132]:38099 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1DNVJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:09:34 -0400
Date: Thu, 14 Apr 2011 23:09:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110414210932.GG18463@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <4DA654D6.2060103@zytor.com> <20110414085624.GC18463@8bytes.org> <BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:28:43AM -0400, Alex Deucher wrote:
> On Thu, Apr 14, 2011 at 4:56 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > And this makes a difference, with this change on-top of -rc3 the box boots
> > fine. So there seems to be some dependency between the GART base and the GTT
> > base even when they are in different address spaces.
> >
> > Alex, can you comment on this?
> 
> As Dave said, they are completely different addresses spaces.  You
> could put the GPU aperture at 0 if you wanted (in fact we do on some
> chips).  Perhaps there's some strange interaction with the nb gart
> since the nb gart on that chipset was designed to be used for graphics
> and the rs780/880 can be configured to use an agp aperture.
> Unfortunately, I'm not that familiar with the nb gart.

Actually, the nb gart is part of the cpu. It is part of the cpu north
bridge and can translate io and cpu accesses. In fact, it is a remapper
of physical memory addresses.

The problem seems to be related to specific gpu chips. On another
notebook with an hd3000 card gtt and the nb gart aperture are both on
0xa0000000 too but the box works fine. I havn't tested with an hd5000
yet. The failing notebook has an hd4200 mobility.

Btw. what happens if the gpu accesses an unmapped address in the gtt
range?

Regards,

	Joerg

