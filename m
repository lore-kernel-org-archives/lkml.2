Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1KESWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 14:22:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52878 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1KESWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 14:22:45 -0400
Date: Sat, 5 Nov 2011 19:22:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Barry Song <Barry.Song@csr.com>
Cc: linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Barry Song <Baohua.Song@csr.com>, Xiangzhen Ye <Xiangzhen.Ye@csr.com>
Subject: Re: [PATCH] PM: HIBERNATION: skip the swap size check if the
 snapshot image size is anticipative
Message-ID: <20111105182244.GB6772@elf.ucw.cz>
References: <1320392176-3906-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320392176-3906-1-git-send-email-Barry.Song@csr.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Barry Song <Baohua.Song@csr.com>
> 
> Current swsusp requires swap partitions even larger than real saved pages
> due to the worst compress ratio:
> but for an embedded system, which has limited storage space, then it might
> can't give the big size partition to save snapshot.
> In the another way, some embedded systems can definitely know the most size
> needed for snapshot since they run some specific application lists.
> So this patch provides the possibility for bootloader to tell kernel even
> the system has a little snapshot partition, but it is still enough.
> For example, if the system need to save 120MB memory, origin swsusp will require
> a 130MB partition to save snapshot. but if users know 30MB is enough for them(
> compressed image will be less than 30MB), they just make a 30MB
> partition.

Would it be better to have /sys/power/... entry which would allow
configuring expected compression ratio at runtime?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
