Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0CaVwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:52:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38428 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932320Ab0CaVwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:52:12 -0400
Date: Wed, 31 Mar 2010 22:55:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100331225500.3ed98c1f@lxorguk.ukuu.org.uk>
In-Reply-To: <201003312304.30917.arnd@arndb.de>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
	<20100331172208.GB5163@nowhere>
	<201003312221.23953.arnd@arndb.de>
	<201003312304.30917.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The recursive users that I've removed in my series are the block, tty,
> input and sound subsystems, as well as the init code.

There are some very subtle recursive cases in the tty code - hangup
triggered close and consoles being an absolute gem I've just had to debug
in my lock removal bits so far...

Alan
