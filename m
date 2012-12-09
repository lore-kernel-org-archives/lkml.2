Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab2LIAus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 19:50:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43947 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2LIAur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 19:50:47 -0500
Date: Sat, 8 Dec 2012 16:50:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@air.linux-foundation.org
To: Mel Gorman <mgorman@suse.de>
cc: Tejun Heo <tj@kernel.org>, Xiaotian Feng <dannyfeng@tencent.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.7-rc8 boot failure due to recent workqueue-related patch
In-Reply-To: <20121208203524.GA1009@suse.de>
Message-ID: <alpine.LFD.2.02.1212081647500.4593@air.linux-foundation.org>
References: <20121208203524.GA1009@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Dec 2012, Mel Gorman wrote:
>
> Commit 8852aac2 (workqueue: mod_delayed_work_on() shouldn't queue timer on
> 0 delay) is causing the following boot failure for me. Found by bisection
> but no further analysis unfortunately until I get back home properly.
> I've added the relevant maintainers for megasas and SCSI in case it's
> somehow specific to that driver.

This should be fixed by commit c1d390d8e612. The Megaraid SAS driver was 
doing insane things, using a work-struct for delayed work, and casting 
pointers around. It had happened to work for all the wrong reasons before, 
the mod_delayed_work_on() changes just exposed how crazy that crap was.

So please test current -git. If it's still broken, we'll need to know, but 
I'm assuming this is the already-known-and-fixed bug.

             Linus
