Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282Ab0EEJS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:18:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab0EEJS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:18:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] tty: turn ldisc_mutex into a regular mutex
Date: Wed, 5 May 2010 11:18:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de> <1273012433-6125-14-git-send-email-arnd@arndb.de>
In-Reply-To: <1273012433-6125-14-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051118.51479.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/HwONhqGzlQlyCpBkK/dTVfnYCbiy2C1B+1vt
 87gamG0TJb/uXAOqQicyK6UreXeCrOzdwOi5DQK/5oUQuXblMu
 VgFzRAgf137SbxM4rlgaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Arnd Bergmann wrote:
> This fixes the lock order of the BTM and
> ldisc_mutex so that we never take the BTM
> while holding ldisc_mutex, which means
> we no longer have to use mutex_lock_tty
> when getting ldisc_mutex.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Ignore this one, I just realized that we're releasing
and reacquiring the BTM in tty_ldisc_halt,
tty_set_termios_ldisc and possibly others.

This patch needs more work to make that possible.

	Arnd
