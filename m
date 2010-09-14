Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0INI7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:59:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0INI7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:59:21 -0400
Date: Tue, 14 Sep 2010 10:59:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix hiddev's use of usb_find_interface
In-Reply-To: <AANLkTikQsu4qo=nkcr2N=_GLmtCgh8wmoRcZFaUJbwAs@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1009141059000.26813@pobox.suse.cz>
References: <1284319955-6014-1-git-send-email-guichaz@gmail.com> <201009131325.01768.arnd@arndb.de> <alpine.LNX.2.00.1009131327060.26813@pobox.suse.cz> <AANLkTikQsu4qo=nkcr2N=_GLmtCgh8wmoRcZFaUJbwAs@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Guillaume Chazarain wrote:

> > Yeah -- Guillaume, I think that you are actually seeing symptoms of
> > intfdata being bogus. Could you please try with any kernel with commit
> > 9c9e54a8df0be48 ("HID: hiddev: fix memory corruption due to invalid
> > intfdata") applied (which is the one Arnd is talking about) and report
> > back whether the problem is fixed by it?
> 
> I also saw the problem with 2.6.36-rc3. My problem is with
> usb_find_interface(&hiddev_driver) not finding anything and
> 9c9e54a8df0be48aa359744f412377cc55c3b7d2 did not change this line.
> 
> In its current state I don't understand how hiddev_open() can possibly
> work. I see people reporting suspend issues and stack traces in dmesg
> but nobody reporting the driver being non-functioning, which is what
> I'm doing here.

You are right. I have now applied your patch, thanks a lot for tracking it 
down.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
