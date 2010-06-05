Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab0FEKHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:07:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957Ab0FEKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:07:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
Subject: Re: [PATCH] remove pointless debug printk in rt_ioctl_giwscan()
Date: Sat, 5 Jun 2010 12:07:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de, bzolnier@gmail.com,
       roel.kluin@gmail.com, devel@driverdev.osuosl.org
References: <1275712909.8509.25.camel@debian-hell>
In-Reply-To: <1275712909.8509.25.camel@debian-hell>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006051207.40040.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19cjWooBCUfRQhUoSRJVybdsbkMxlMKjtRLaHD
 R71MfqQwvNvz54Ixv0Sf7DTk/0Nt16nVM9Ep6Rnvj2Qus7tNkq
 RDqNbMvZsSRrK5BcHhW4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010, Giangiacomo Mariotti wrote:
> This debug printk is only useful if you're debugging the staging drivers
> 2860 e 2870, but, if you're just using them, it becomes really annoying, because
> it uselessly clobbers the kernel log. I guess this patch shouldn't really get merged,
> but it's more like a request to remove these annoying debugging messages for normal users.
> If I get any suggestion on how to implement this in a way acceptable to get it merged, I'll
> be happy to create the "good" version  of the patch.

Ideally, drivers should not have their own debugging macros like this, but
instead use the kernel's own pr_debug() and (preferrably) dev_dbg() macros,
which are disabled by default.
For many of these debugging outputs, it's even better to kill them entirely
instead of converting to dev_dbg().
Do not put the line in comments though.

	Arnd
