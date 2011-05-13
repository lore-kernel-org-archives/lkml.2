Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab1EMQMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:12:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48225 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757619Ab1EMQMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:12:39 -0400
Subject: Possible sandybridge livelock issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: x86@kernel.org
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 11:12:36 -0500
Message-ID: <1305303156.2611.51.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've just come off a large round of debugging a kswapd problem over on
linux-mm:

http://marc.info/?t=130392066000001

The upshot was that kswapd wasn't being allowed to sleep (which we're
now fixing).  However, in spite of intensive efforts, the actual hang
was only reproducible on sandybridge laptops.

When the hang occurred, kswapd basically pegged one core in 100% system
time.  This looks like there's something specific to sandybridge that
causes this type of bad interaction.  I was wondering if it could be
something to to with a scheduling problem in turbo mode?  Once kswapd
goes flat out, the core its on will kick into turbo mode, which causes
it to get preferentially scheduled there, leading to the live lock.

The only evidence I have to support this theory is that when I reproduce
the problem with PREEMPT, the core pegs at 100% system time and stays
there even if I turn off the load.  However, if I can execute work that
causes kswapd to be kicked off the core it's running on, it will calm
back down and go to sleep.

James


