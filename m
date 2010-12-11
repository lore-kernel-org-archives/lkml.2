Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab0LKT7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 14:59:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46275 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab0LKT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 14:59:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature to avoid user space breakage
Date: Sat, 11 Dec 2010 20:58:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Karel Zak <kzak@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
References: <201012052324.30231.rjw@sisk.pl> <1291592215.2866.3.camel@shrek.rexursive.com>
In-Reply-To: <1291592215.2866.3.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012112058.09689.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010, Bojan Smojver wrote:
> On Sun, 2010-12-05 at 23:24 +0100, Rafael J. Wysocki wrote:
> > Commit 3624eb0 (PM / Hibernate: Modify signature used to mark swap)
> > modified hibernate signature used to mark swap partitions containing
> > hibernation images, but that turns out to have caused problems in
> > libblkid on recent Ubuntu.  Restore the old signature to avoid those
> > problems. 
> 
> Don't quite understand this change (sorry, probably just being obtuse).
> 
> The signature was changed to make sure older kernels don't handle
> compressed images by accident, right? If so, this would seem like a bad
> idea, because this is what can actually happen now.
> 
> Shouldn't user space learn how to handle both signatures instead?

I'm afraid I'll have to push this patch to Linus.  Turns out that Fedora 14
doesn't pass the resume= argument to the kernel and tries to trigger the resume
from initramfs.  Since the signature changed, it can't find the image and the
resume fails, even if both the resume and image kernels are the same.

Thanks,
Rafael
