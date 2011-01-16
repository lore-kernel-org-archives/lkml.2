Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1APXGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:06:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44875 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1APXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:06:17 -0500
Date: Sun, 16 Jan 2011 23:06:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joachim Eastwood <manabian@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2 (automount work)
Message-ID: <20110116230614.GE22723@ZenIV.linux.org.uk>
References: <20110116185745.GB22723@ZenIV.linux.org.uk>
 <AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
 <AANLkTinZ5ng+hbOHz7DKy82HPqFwYhQvmmbM+ioSWp9x@mail.gmail.com>
 <20110116214426.GD22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110116214426.GD22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 09:44:26PM +0000, Al Viro wrote:

> Already fixed.  Actually, taking it out of ifdef would work (the only
> place that actually cares about the value of that sucker is SMP side
> of mntput()), but we are obviously better off just not touching it on
> UP at all - why do pointless work and waste space?
> 
> See the patch upthread.  ->mnt_longterm is SMP-only optimization of
> mntput(); it's there only to free the common case of mntput() from
> cacheline bouncing and on UP it's needed at all.

PS: the patch does survive UP beating.  Could you pull
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus ?
There's only one patch at the moment:

Al Viro (1):
      mnt_longterm is there only on SMP

 fs/namespace.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

