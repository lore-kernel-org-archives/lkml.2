Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2BEKdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 05:33:47 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:51603 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2BEKdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 05:33:46 -0500
Message-ID: <4F2E5B08.4010200@msgid.tls.msk.ru>
Date: Sun, 05 Feb 2012 14:33:44 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110805 Icedove/5.0
MIME-Version: 1.0
To: Harald Dunkel <harri@afaics.de>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: /proc/self/mounts in chroot vs lxc
References: <4F2E4120.3030506@afaics.de>
In-Reply-To: <4F2E4120.3030506@afaics.de>
X-Enigmail-Version: 1.2.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.02.2012 12:43, Harald Dunkel wrote:
> Hi folks,
> 
> AFAIK /proc/mounts (-> self/mounts) is supposed to replace
> /etc/mtab. Problem is: In a chroot it contains too much
> (invalid) information about the parent's mount points. It is
> very hard to figure out which lines are correct.
> 
> For lxc there seems to be no such problem, so I wonder if it
> would be possible to extend this scheme to chroot?
> 
> I am not sure if this is a kernel or libc issue. Any helpful
> comment would be highly appreciated.

/proc is _always_ kernel thing.

For lxc, it creates a separate namespace where all "extra" mounts
are unmounted.  So /proc/mounts does not contain unnecessary
entries.

But plain chroot does not create new namespace, the process inherits
parent namespace, so there is no way to clean in up cleanly.

This is how it always worked, I'd say it is too late to change
this, and changing it isn't really trivial due to various
implications bind mounts are giving us.

I think anway.

/mjt.
