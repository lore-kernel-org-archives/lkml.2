Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1BHMNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:13:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39117 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753568Ab1BHMM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:12:58 -0500
Date: Tue, 8 Feb 2011 12:12:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110208121254.GE29850@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201102072046.48763.rjw@sisk.pl>
 <20110207201803.GU10564@opensource.wolfsonmicro.com>
 <201102072215.59921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102072215.59921.rjw@sisk.pl>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 10:15:59PM +0100, Rafael J. Wysocki wrote:

> I really think we should do things that makes sense rather that worry about
> who's going to like or dislike it (except for Linus maybe, but he tends to like
> things that make sense anyway).  At this point I think the change I suggested
> makes sense, because it (a) simplifies things and (b) follows the quite common
> practice which is to make PM callbacks depend on CONFIG_PM.

So, part of the issue here is that it's not clear if having the ifdefs
in the drivers is really something that makes sense.  It's not at all
clear that anyone is actually making active use of them on real systems
rather than just doing build coverage testing, it really feels like the
ifdefs that people are currently using are just being cargo culted
around.

The reason it's come up for me is that dev_pm_ops changes things a bit
as you've got to decide how to handle the struct itself and there's no
clear decision on what the best way forward for that is (is it OK to
leave the struct if it's empty?) so you end up with the approach you
need to take varying between maintainers which is annoying.

> I'd appreciate it if people could review/test it and drop their comments.

Looks good to me:

Reviewed/Tested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
