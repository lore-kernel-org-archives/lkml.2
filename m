Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab0D1U3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0D1U3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:29:33 -0400
Date: Wed, 28 Apr 2010 16:28:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 8/8] [watchdog] separate touch_nmi_watchdog code path
 from touch_watchdog
Message-ID: <20100428202849.GS15159@redhat.com>
References: <1272039216-8890-1-git-send-email-dzickus@redhat.com>
 <1272039216-8890-9-git-send-email-dzickus@redhat.com>
 <20100428124815.GB12017@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428124815.GB12017@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 02:48:18PM +0200, Frederic Weisbecker wrote:
> On Fri, Apr 23, 2010 at 12:13:36PM -0400, Don Zickus wrote:
> > When I combined the nmi_watchdog (hardlockup) and softlockup code, I
> > also combined the paths the touch_watchdog and touch_nmi_watchdog took.
> > This may not be the best idea as pointed out by Frederic W., that the
> > touch_watchdog case probably should not reset the hardlockup count.
> > 
> > Therefore the patch belows falls back to the previous idea of keeping
> > the touch_nmi_watchdog a superset of the touch_watchdog case.
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> 
> 
> 
> Good. But now that we have this, it doesn't make sense anymore
> to have the big rename touch_softlockup_watchdog() into touch_watchdog().
> 
> I know it was me who advised you to do this big rename, but that was
> before I realised touching the softlockup shouldn't mean touching nmi
> watchdog too.
> 
> I'm sorry about this but this big rename doesn't make sense anymore.
> 
> Can we drop touch_watchdog() and keep only the two previous APIs we had
> before?
> 
> 1) we avoid a big patch very likely to bring conflicts everywhere
> 2) touch_softlockup_watchdog() is much more self-explanatory in what
>    it does. People will have less doubts about what happens when they
>    call this.
> 
> Thanks.

ok.  I'll repost.

Cheers,
Don

> 
