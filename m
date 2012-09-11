Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab2IKXZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:25:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2IKXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:25:39 -0400
Date: Tue, 11 Sep 2012 16:25:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Rientjes <rientjes@google.com>, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        Andrew Morton <akpm@osdl.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: iwl3945: order 5 allocation during ifconfig up; vm problem?
Message-Id: <20120911162536.bd5171a1.akpm@linux-foundation.org>
In-Reply-To: <20120910111113.GA25159@elf.ucw.cz>
References: <20120909213228.GA5538@elf.ucw.cz>
	<alpine.DEB.2.00.1209091539530.16930@chino.kir.corp.google.com>
	<20120910111113.GA25159@elf.ucw.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012 13:11:13 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Sun 2012-09-09 15:40:55, David Rientjes wrote:
> > On Sun, 9 Sep 2012, Pavel Machek wrote:
> > 
> > > On 3.6.0-rc2+, I tried to turn on the wireless, but got
> > > 
> > > root@amd:~# ifconfig wlan0 10.0.0.6 up
> > > SIOCSIFFLAGS: Cannot allocate memory
> > > SIOCSIFFLAGS: Cannot allocate memory
> > > root@amd:~# 
> > > 
> > > It looks like it uses "a bit too big" allocations to allocate
> > > firmware...? Order five allocation....
> > > 
> > > Hmm... then I did "echo 3  > /proc/sys/vm/drop_caches" and now the
> > > network works. Is it VM problem that it failed to allocate memory when
> > > it was freeable?
> > > 
> > 
> > Do you have CONFIG_COMPACTION enabled?
> 
> Yes:
> 
> pavel@amd:/data/l/linux-good$ zgrep CONFIG_COMPACTION /proc/config.gz 
> CONFIG_COMPACTION=y

Asking for a 256k allocation is pretty crazy - this is an operating
system kernel, not a userspace application.

I'm wondering if this is due to a recent change, but I'm having trouble
working out where the allocation call site is.
