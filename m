Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965786Ab2CAVvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:51:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab2CAVvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:51:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/6] vt: push down the tty lock so we can see what is left to tackle
Date: Thu, 1 Mar 2012 21:51:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <20120301194831.11322.38295.stgit@bob.linux.org.uk> <20120301195005.11322.78572.stgit@bob.linux.org.uk>
In-Reply-To: <20120301195005.11322.78572.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012151.20940.arnd@arndb.de>
X-Provags-ID: V02:K0:9AUVk1foDNy1D5QUn86GoUJRplTOKiOMCOJIXN3aT6K
 5hQCAeZhUcJlGZLHbBrLc1puLpKxi3+I935/7oojoAMWrBZBFX
 4KsuDM0aU5M5EW9nS265YSZ6OATY/uKdDsqOO6JTIk7eE40EdF
 lsjQIIksmtyw1hQu+1+ENWrepFJFq7Wd+1JXKJNpo+U/0siQz0
 VW4O2uzH0JHfkVifvw26ULwHkOcLrbTmIS/uEg+iq/thOxCZL1
 FtlrJcdEg7T/qLCSp/2YyG8snkpeze0eNJw3ZZcA75KItRICFw
 +kRecKgDkMm+RPTEQYnlOIj2hfvBDSBACXDbBOK+T+MMAA792T
 GZSm8ldeEsvO1FudjT2Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Alan Cox wrote:
> @@ -1407,6 +1425,7 @@ int vt_move_to_console(unsigned int vt, int alloc)
>                 return -EIO;
>         }
>         console_unlock();
> +       /* Review: I don't see why we need tty_lock here FIXME */
>         tty_lock();
>         if (vt_waitactive(vt + 1)) {
>                 pr_debug("Suspend: Can't switch VCs.");

I'm pretty sure I only added this in be1bc288 "tty: introduce
wait_event_interruptible_tty" so I could release the mutex again in
vt_event_wait.

All other callers of that function hold it, so it needs to be released
in vt_event_wait and that can only be done if it's known to be held first.

	Arnd
