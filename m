Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1ILO6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:58:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41561 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab1ILO62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:58:28 -0400
Date: Mon, 12 Sep 2011 10:58:14 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Sasha Levin <levinsasha928@gmail.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110912145814.GB29050@hmsreliant.think-freely.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <1315417137-12093-1-git-send-email-jarod@redhat.com>
 <1315419179.3576.6.camel@lappy>
 <4E67B75B.8010500@redhat.com>
 <20110907192737.GD20571@thunk.org>
 <4E6E1103.2000408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6E1103.2000408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.3 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 10:02:43AM -0400, Jarod Wilson wrote:
> Ted Ts'o wrote:
> >On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
> >>We're looking for a generic solution here that doesn't require
> >>re-educating every single piece of userspace. And anything done in
> >>userspace is going to be full of possible holes -- there needs to be
> >>something in place that actually *enforces* the policy, and
> >>centralized accounting/tracking, lest you wind up with multiple
> >>processes racing to grab the entropy.
> >
> >Yeah, but there are userspace programs that depend on urandom not
> >blocking... so your proposed change would break them.
> 
> I'm already consigned to the fact this isn't going to fly, but I'm
> still curious to know examples of programs that are going to break
> here, for my own education. Its already possible for urandom reads
> to fail as the code is now (-ERESTARTSYS and -EFAULT are possible),
> so a sane program ought to already be handling error cases, though
> not -EAGAIN, which this would add.
> 
Its not a failure return code here, its the possibility of no return code at all
(i.e. indefinte blocking).  While I can't cite a specific application the
failure profile would be an application holding a critical system resource say a
manditory file lock that several applications require to do their work).  If the
application that holds said lock blocks on urandom (having previously correctly
assumed that no blocking could occur), all applications requiring access to that
file lock then in turn block indefinately, violating any time critical deadlines
they may have.

Neil

> 
> -- 
> Jarod Wilson
> jarod@redhat.com
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
