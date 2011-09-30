Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab1I3SCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:02:55 -0400
Received: from websrv.saout.de ([78.46.99.52]:60298 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723Ab1I3SCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:02:52 -0400
Subject: Re: [dm-devel] Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1317397918.27140.15.camel@localhost>
References: <1317397918.27140.15.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 20:02:11 +0200
Message-ID: <1317405732.20365.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

> Today I was trying to boot a new 3.1 RC kernel on one of our server
> machines and ran into a weird block-related crash.
> 
> Whenever I was trying to access some filesystem on the external RAID, I
> would soon run into the crash seen below, followed by a total lockup a
> bit later.
> 
> The external RAID is accessed via multipath and simple logical volumes
> on top. [...]
>
> The bug seems to be introduced between rc2 and rc3. Up to rc2 everything
> is fine, and rc3 and also the latest kernel shows this bug. From the git
> log I can see that the block/ directory has seen some larger update, but
> this is just a wild guess.

Actually, I just found out that reverting

commit 4853abaae7e4a2af938115ce9071ef8684fb7af4
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Mon Aug 15 21:37:25 2011 +0200

    block: fix flush machinery for stacking drivers with differring flush flags

makes the problem disappear.

Let me know if I can help with further information.

Cheers,
	Christophe


