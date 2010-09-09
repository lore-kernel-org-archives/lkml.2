Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0IIMWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:22:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32770 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0IIMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KFqv/tInZ0NC3OHSLqdS+8f/2sHaUSMhqBlqElxCh3gkRgc+Uc+TgTQO1cyvoGj4sK
         6vDwaNyGORcH8+unopIZhzchrzSsLZf35DJmUL++Be+sv1SrzEiP4CePnmpB+7nBzKk2
         Pd9lrto8t5ZZgbyaz9jtWw+drHsImRgDYJ5dM=
Date: Thu, 9 Sep 2010 14:21:56 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
Message-ID: <20100909122156.GA2823@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <alpine.LFD.2.00.1009091152300.2477@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009091152300.2477@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 11:58:09AM +0200, Thomas Gleixner wrote:
> On Fri, 3 Sep 2010, Richard Cochran wrote:
> 
> > Recently on the lkml, we discussed how to allow adjustment of posix
> > clocks. I have tried to understand and implement the ideas expressed
> > in the various threads.
> 
> Cc'ing the relevant maintainers to such discussions and patches might
> be helpful. Seems I need to do some archive digging.

Sorry about that. Still learning how to work on the list.  The story
so far is...

** PTP hardware clock as a character device (54 messages)

   http://lkml.org/lkml/2010/8/16/90

   The general mood of this was something like: "You have made a
   chardev for PTP clocks. The ioctls look similar to the posix clock
   api. Why not just use the posix api?"

** posix clock tuning syscall, static clockid (13 messages)

   http://lkml.org/lkml/2010/8/23/49

   The general mood of this one was: "I don't like a static clockid
   for PTP clocks. But a dynamic id would be just fine."

** posix clock tuning syscall, dynamic clockid (16 messages)

   http://lkml.org/lkml/2010/9/3/119 (This thread)

   The mood seems to be, "why not use a chardev for that?"

>From my point of view, the discussion is going round in circles. There
seems to be agreement that supporting PTP hardware clocks is a good
idea. The objections seem to be about the form of the API. In general,
there are three avenues.

1. character device (like hpet)
2. posix clock api
3. sysfs

Or possibly some combination of the three.

I have my preference, but I am willing to work it according to
taste. Would you have some preference?

> > If there is agreement on this approach, I will resubmit these two
> > patches as part of a longer series, including support for a new kind
> > of hardware clock, so you can see how it all fits together. But first,
> > I would like to concentrate on the new syscall itself.
> > 
> > The patches are against a recent net-next tree. Please don't worry if
> > the syscall tables are not quite up to date. I can fix that later.
> 
> How is this related to net-next ? 

The whole hardware timestamping and PTP clock issue is somewhat
network related. In particular, needed to start there to get some
background support for timestamping within PHY devices.

Thanks,

Richard
