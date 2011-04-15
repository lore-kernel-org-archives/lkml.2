Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1DOGuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:50:19 -0400
Received: from 8bytes.org ([88.198.83.132]:40224 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab1DOGuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:50:19 -0400
Date: Fri, 15 Apr 2011 08:50:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415065017.GH18463@8bytes.org>
References: <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <4DA654D6.2060103@zytor.com> <20110414085624.GC18463@8bytes.org> <BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com> <20110414210932.GG18463@8bytes.org> <BANLkTimRrx-QLPWwJx37qWhtwhdC8RTpsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimRrx-QLPWwJx37qWhtwhdC8RTpsQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 05:34:46PM -0400, Alex Deucher wrote:
> On Thu, Apr 14, 2011 at 5:09 PM, Joerg Roedel <joro@8bytes.org> wrote:

> > Actually, the nb gart is part of the cpu. It is part of the cpu north
> > bridge and can translate io and cpu accesses. In fact, it is a remapper
> > of physical memory addresses.
> 
> I know what it's for.  In the IGP graphics chip is also part of the
> north bridge, but it may not be related at all.

Okay, just wanted to make clear that it is part of the CPU and not of
the chipset :)

> > The problem seems to be related to specific gpu chips. On another
> > notebook with an hd3000 card gtt and the nb gart aperture are both on
> > 0xa0000000 too but the box works fine. I havn't tested with an hd5000
> > yet. The failing notebook has an hd4200 mobility.
> 
> What exact model is the hd3000?   Is it IGP GPU or a discrete GPU?  It
> it's an IGP, it's identical to the hd4200 programming-wise.

It is an IGP card, an 

	"ATI Technologies Inc RS780M/RS780MN [Radeon HD 3200 Graphics]"

according to lspci.

> > Btw. what happens if the gpu accesses an unmapped address in the gtt
> > range?
> 
> It's redirected to a dummy page.

So there should be no issue too, this is a very weird bug.

	Joerg

