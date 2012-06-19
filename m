Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2FSS5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:57:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55203 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414Ab2FSS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:57:40 -0400
X-Sasl-enc: GwKF5xX62oyCv9ouHQTI7jkbWYLhhZOG2k4QCAo1i4y+ 1340132259
Date: Tue, 19 Jun 2012 15:57:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619185736.GD18816@khazad-dum.debian.net>
References: <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
 <20120619050325.GA31591@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619050325.GA31591@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Borislav Petkov wrote:
> On Mon, Jun 18, 2012 at 11:46:39PM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 15 Jun 2012, Borislav Petkov wrote:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > Date: Fri, 15 Jun 2012 18:46:05 +0200
> > > Subject: [PATCH] x86, microcode: Make reload interface per system
> > > 
> > > The reload interface should be per-system so that a full system ucode
> > > reload happens (on each core) when doing
> > > 
> > > echo 1 > /sys/devices/system/cpu/microcode/reload
> > > 
> > > Move it to the cpu subsys directory instead of it being per-cpu.
> > > 
> > > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > It is a pity this one is much harder to backport to 3.2 and 3.0.
> 
> Yeah, not harder. It changes the sysfs interface and we can't do that
> for already released kernels.
> 
> But I think you meant that.

Yeah.

I was wondering whether it would be worthwhile to backport the new ABI for
the Debian 3.2 kernel or not.  Probably not.

Backporting to 3.2 and 3.0 is straigthforward, however it will look nasty as
one has to "inappropriately touch" the cpu sysdev class to get the attribute
group directly connected to /sys/devices/system/cpu.

I did notice there were no stable backports of the error unwind during
module init, but that one is a very rarely used codepath.  Maybe worth to
backport a fix to stable, though.

> > I'd really like to have the new interface there. But it looks good,
> > and we will support the new /sys/devices/system/cpu/microcode/reload
> > sysfs node in Debian for the benefit of anyone using a newer kernel
> > than the distro's (which will be based on 3.2).
> 
> Right, hopefully the next Debian release will have that nice shiny new
> interface :-)

I sure hope so :)  Actually, I hope Debian will release a
"stable-and-a-half" that will already have it.

> > So, fwiw, you have my:
> > Acked-by-unimportant-person: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 
> No, don't underestimate yourself. I think it helps a lot to have someone
> look at the patch and even better: give comments whether what we're
> doing is sane for userspace. So, I appreciate your comments a lot, keep
> 'em coming :-)

Well, my ack is unimportant in the "this is not an area of the kernel I have
any authority to ack things" sense.  But we don't have a "I-wanna-that-by:"
or even a "Thumbs-up-by:"...

> Thanks for review and testing, I'll send out the patches soon.

Thank you for addressing these issues and writing the patches!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
