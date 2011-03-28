Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1C1HGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:06:39 -0400
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:53121 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab1C1HGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:06:38 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 28 Mar 2011 09:10:16 +0200
To: Jeffrey Brown <jeffbrown@android.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] input: Set default events per packet.
Message-ID: <20110328071016.GA6863@polaris.bitmath.org>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-2-git-send-email-jeffbrown@android.com>
 <20110325082030.GB5664@polaris.bitmath.org>
 <AANLkTi=KotXd4TyyUrhMdKn3mEq+pz2ac3Vnraa5udFh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=KotXd4TyyUrhMdKn3mEq+pz2ac3Vnraa5udFh@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q46WU-0000fT-JB.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1Q46WU-0000fT-JB 149721222d5f6dea895cb66c06f1bc8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Originally, I set an arbitrary maximum bound of 20 slots.  In the
> interests of keeping it simple, I decided to remove that bound when I
> submitted the patch for review here.
> 
> How about:
> 
> mt_slots = min(MAX_MT_SLOTS_TO_INFER_FROM_TRACKING_ID_RANGE,
>    dev->absinfo[ABS_MT_TRACKING_ID].maximum -
> dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1);
> 
> Where MAX_MT_SLOTS_TO_INFER_FROM_TRACKING_ID_RANGE is set to 32 or something.

Sure, 32 works for me.

> There's also the question of how many slots we should infer when
> neither ABS_MT_SLOT or ABS_MT_TRACKING_ID is available.  The drivers
> I've seen that don't provide tracking ids, are very basic and tend to
> only support 2 touch points.

There is the bcm5974 driver, but it sets its own limit, so 2 is fine.

> I guess we could add a DEFAULT_NUMBER_OF_MT_SLOTS constant to handle that case.
> 
> Please feel free to suggest better names for these constants.

With the same interest of keeping it simple in mind, inserting the
actual values is fine. We do not expect to duplicate the decisions
made in this function anywhere else.

Thanks,
Henrik
