Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2D1GNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 02:13:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2D1GM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 02:12:58 -0400
Date: Fri, 27 Apr 2012 23:14:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 4/4] bug: mark disabled BUG() as unreachable() code
Message-Id: <20120427231452.21afc293.akpm@linux-foundation.org>
In-Reply-To: <4F9B7BBA.7030504@openvz.org>
References: <20120425112623.26927.43229.stgit@zurg>
	<20120425112636.26927.27124.stgit@zurg>
	<4F9B7BBA.7030504@openvz.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2012 09:10:18 +0400 Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Konstantin Khlebnikov wrote:
> > This patch suppress some compiler warnings (if CONFIG_BUG=n)
> > "warning: control reaches end of non-void function"
> 
> With this patch gcc throw out loop at the end of do_exit():
> 
> 	schedule();
> 	BUG();
> 	/* Avoid "noreturn function does return".  */
> 	for (;;)
> 		cpu_relax();	/* For when BUG is null */
> 
> Is this ok? Probably not, and we need here some BUG_NORETURN() which
> really never returns even if CONFIG_BUG=n.

Probably we should do away with CONFIG_BUG.

CONFIG_BUG=n causes various compile-time warnings to come out when the
execution proceeds into places where we didn't intend and these aren't
worth fixing.

More seriously, I rather doubt that anyone ever sets it to n.  And it
would be a pretty dumb thing to do - if your kernel has seriously
malfunctioned and it *knows* that it malfunctioned, it will just
blunder on anyway not telling anyone about it.

It doesn't seem worth any effort to support this thing.
