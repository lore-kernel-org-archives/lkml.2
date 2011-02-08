Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1BHOPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:15:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52543 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752600Ab1BHOPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:15:41 -0500
Date: Tue, 8 Feb 2011 14:15:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110208141539.GI29850@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4D50AFD0.9020704@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D50AFD0.9020704@am.sony.com>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 06:52:00PM -0800, Frank Rowand wrote:
> On 02/07/11 04:22, Mark Brown wrote:

> > Since having the configuration option requires non-zero effort to
> > maintain, with ifdefery in most drivers, but it is used with vanishing
> > rarity it is simpler to just remove the option.

> Proof by assertion that it is used with vanishing rarity.

Sure, hopefully if it's incorrect people will come out of the woodwork
to correct me :)

> That is not a good method of getting feedback from users.

>  1) It immediately removes the ability to have CONFIG_PM undefined,
>     without first giving active users a chance to provide feedback.

Note that it's not a terribly difficult change to reverse; if someone
urgently does need to do so then I'd be surprised if they were able to
build a kernel but not cope with that change.

>  2) The removal of that ability is not obvious ("make oldconfig" does
>     not say anything about CONFIG_PM).  It is easy to overlook a
>     config change that happens silently.

It will expose the sub-options which actually do stuff, though - it's
only the top level option for PM.

> Would it be appropriate to use Documentation/feature-removal-schedule.txt
> if this truly will be removed?

I guess, though I'm a bit pessimistic about anyone actually noticing.
With Raphael's version it's not such a big deal as CONFIG_PM is selected
by other options that previously depended on it instead of being enabled
all the time.
