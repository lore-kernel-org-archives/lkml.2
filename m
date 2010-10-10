Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0JJRID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0JJRIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:08:01 -0400
Date: Sun, 10 Oct 2010 13:07:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010170750.GA1475@redhat.com>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
 <20101010162257.GA1272@redhat.com>
 <4CB1ECCA.8040801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1ECCA.8040801@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10 2010 at 12:41pm -0400,
Milan Broz <mbroz@redhat.com> wrote:

> On 10/10/2010 06:22 PM, Mike Snitzer wrote:
> > If you feel you shouldn't be doing any more to your split patches then
> > I'll review all of this closer tomorrow.
> 
> I think there was small bugfix in my patchset (some missing free in error path)
> and I change to use generic per-cpu IV struct (not ESSIV only) -
> see patch already sent here https://www.redhat.com/archives/dm-devel/2010-July/msg00118.html

Sure, but Andi's v3 was adjusted with "Mark per CPU crypto work queues
as CPU intensive."  Do your split patches do that?  I haven't looked at
the actual changes closely yet, just patch headers...
 
> Others are just small code shuffle changes (which I know agk is doing to all patches;-)

If this area is being actively changed behind the scenes then it is
pointless to try to make sense of this now.  As you said, Alasdair needs
to delegate and remove any doubt about where this patchset stands.

> I'll send patch on top of Andi's v3 if it helps something. (When back to my devel machine).

That'll be helpful (I'm sure Andi is interested).  In addition, updating
your split patches like I suggested in my previous mail would be great
too:
1) combine patch 1 and 2 so result bisect safe
2) fold Andi's v3 changes into the appropriate patch(es) of your split
   patchset

In the end I'd expect your (3?) split patches to be functionally
identical to Andi's v3 patch (only differences being the missing free
fix and your using per-cpu of a more generic IV struct).

So expressing your differences as a follow-on patch ontop of Andi's v3
patch would be great.  If Andi agrees with those changes then we can use
your split patches for the final commit sequence.

All patches would have both Andi's and your Signed-off-by.

Thanks,
Mike
