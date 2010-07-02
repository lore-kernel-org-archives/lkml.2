Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0GBH0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:26:23 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:35102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0GBH0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:26:21 -0400
Subject: Re: macbook webcam no longer works on .35-rc
From: Johannes Berg <johannes@sipsolutions.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1277932269.11050.1.camel@jlt3.sipsolutions.net>
References: <1277932269.11050.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 09:26:15 +0200
Message-ID: <1278055575.3737.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 23:11 +0200, Johannes Berg wrote:
> I'm pretty sure this was a regression in .34, but haven't checked right
> now, can bisect when I find time but wanted to inquire first if somebody
> had ideas. All I get is:
> 
> [57372.078968] uvcvideo: Failed to query (130) UVC control 5 (unit 3) :
> -32 (exp. 1).

Didn't have to bisect it. The problem is caused by

commit 59529081e092506edb81a42d914e2d0522f65ca7
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Sat Jan 23 06:30:20 2010 -0300

    V4L/DVB: uvcvideo: Cache control min, max, res and def query results

which reverts cleanly, but then the driver doesn't compile and one also
needs to revert

commit cf7a50eeb6f462a0b7d1619fcb27a727a2981769
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Sun Apr 25 16:27:14 2010 -0300

    V4L/DVB: uvcvideo: Prevent division by 0 when control step value is 0

and

commit e54532e591cd5b9ce77dbc8d9786ae9f600f101a
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Sat Jan 23 07:07:53 2010 -0300

    V4L/DVB: uvcvideo: Clamp control values to the minimum and maximum values


in that order.

These are commits introduced in the .34/.35 cycles. Please fix.

Can we revert things that are regressions pre-dating the current kernel
version?

johannes

