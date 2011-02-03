Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1BCWCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:02:46 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63134 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1BCWCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:02:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=I9KjeCWqk3tfaVtC+/iFvyaPFE1VGUIJ/msdpy6+oy5yFNHr9QsXSr7AJlBmBc0ssM
         bmsR3Ct7ArXPEOqcUx5g5S8spwaYpzIPFp3ld7oYLLlEDzpeKjI5ZsHfT/MrrAJV6Ked
         M2fnsU59yRn18uTZDIsqEQFp964cfFeqmypVI=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] XFS update for 2.6.38-rc3
Date: Thu, 3 Feb 2011 23:02:31 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37; KDE/4.6.0; x86_64; ; )
Cc: Dave Chinner <david@fromorbit.com>, Mark Lord <kernel@teksavvy.com>,
        Alex Elder <aelder@sgi.com>, stable@kernel.org
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com> <4D482E21.5040803@teksavvy.com> <20110203000757.GT11040@dastard>
In-Reply-To: <20110203000757.GT11040@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102032302.31780.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 of February 2011, Dave Chinner wrote:
> On Tue, Feb 01, 2011 at 11:00:33AM -0500, Mark Lord wrote:
> > On 11-01-31 11:42 AM, Alex Elder wrote:
> > > Linus, please accept the following updates for XFS, for 2.6.38-rc3
> > > (if it's not too late) or 2.6.38-rc4.
> > > 
> > > They are all fixes for bugs that have some pretty undesirable
> > > consequences. 

[...]

> > Are these bugs all new in 2.6.38, or should some of these fixes
> > also go out to -stable for earlier revisions?
> > >       xfs: fix dquot shaker deadlock
> 
> That's a regression, so maybe.

Definitely, xfs_fsr can hit this even few times a day (happened already).

Stable team, please include this one for 2.6.37.1:

commit 0fbca4d1c3932c27c4794bf5c2b5fc961cf5a54f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 28 11:20:46 2011 +1100

    xfs: fix dquot shaker deadlock

    Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
    to unlock the dquot freelist when the number of loop restarts is
    exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
    reclaim.

    Rework the loop control logic into an unwind stack that all the
    different cases jump into. This means there is only one set of code
    that processes the loop exit criteria, and simplifies the unlocking
    of all the items from different points in the loop. It also fixes a
    double increment of the restart counter from the qi_dqlist_lock
    case.

    Reported-by: Malcolm Scott <lkml@malc.org.uk>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Alex Elder <aelder@sgi.com>


> Cheers,
> 
> Dave.


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
