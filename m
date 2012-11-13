Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2KMI0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:26:40 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:40218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2KMI0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:26:35 -0500
Message-ID: <1352795227.9466.8.camel@jlt4.sipsolutions.net>
Subject: Re: removal of sysfs wext extension broke on F16
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Airlie <airlied@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Nov 2012 09:27:07 +0100
In-Reply-To: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>
References: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 07:52 +1000, Dave Airlie wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=875328
> 
> blamed for breaking wireless.
> https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=35b2a113cb0298d4f9a1263338b456094a414057
> 
> apparantly the initscripts used the sysfs directory existance as a
> check, so maybe either back this out or bring back just the subdirs.

OK. I really thought nobody was using it, but we can of course revert it
for Fedora's benefit, it's optional anyway.

FWIW, for most drivers you could check if the sys/class/net/$1/phy80211
symlink exists, but that doesn't work for older wext-only drivers (or
say the crap Broadcom binary STA driver.)

Should I revert it and send it in my next pull request?

johannes

