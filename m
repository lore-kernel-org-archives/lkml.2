Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0C3Ki0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:38:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0C3KiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:38:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/6] procfs: Push down the bkl from ioctl
Date: Tue, 30 Mar 2010 11:37:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-6-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1269930015-863-6-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301237.28083.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aRn3ymM0zh7IVlAKGgoL1YhDZ5xMcr1nqq6r
 Shoi9T75xg4BZY1aRzbeofDgcH52iP93VBx8rfIglEm/+M5lwY
 hjdPXVW+G/DMq8GDpyS4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> Push down the bkl from procfs's ioctl main handler to its users.
> Only three procfs users implement an ioctl (non unlocked) handler.
> Turn them into unlocked_ioctl and push down the Devil inside.

Looks good to me. I would have used a single unlock and return statement
in i8k_ioctl and isdn_divert_ioctl, with goto instead of adding an
unlock to each return, but it doesn't matter much.

Acked-by: Arnd Bergmann <arnd@arndb.de>
