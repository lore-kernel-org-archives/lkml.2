Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2JBUdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:33:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48035 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab2JBUda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:33:30 -0400
Date: Tue, 2 Oct 2012 13:32:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Shuah Khan <shuah.khan@hp.com>
cc: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: kernel null pointer dereference at kmem_cache_alloc+0x5b/0x140
In-Reply-To: <1349201166.3141.37.camel@lorien2>
Message-ID: <alpine.LSU.2.00.1210021328090.1700@eggly.anvils>
References: <1349201166.3141.37.camel@lorien2>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Shuah Khan wrote:
> I started seeing the following null pointer dereference on
> a linux-next sept 21 git and still seeing it on linux-next 
> Sep 27th git.
> 
> Can be reproduced easily. I have been able to reproduce every
> time I do a complete build of a kernel on fresh checkout or
> touch a header file that forces full build.
> 
> I didn't get a chance to investigate this yet, thought I would
> share just in case others have seen it.
> 
> [11478.881196] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> [11478.881245] IP: [<ffffffff811742bb>] kmem_cache_alloc+0x5b/0x140
> [11478.881277] PGD 74386067 PUD 5dfab067 PMD 0 
> [11478.881302] Oops: 0000 [#2] SMP 
> [11478.881705] CPU 0 
> [11478.881717] Pid: 6399, comm: ld Tainted: G      D      3.6.0-rc7-next-20120927+ #1 Hewlett-Packard HP EliteBook 6930p/30DC
> [11478.884005] Process ld (pid: 6399, threadinfo ffff88005dec0000, task ffff88007bf244a0)
> [11478.884005] Call Trace:
> [11478.884005]  [<ffffffff8125dab1>] ext4_es_insert_extent+0x1e1/0x2f0

ext4_es_insert_extent again: probably fixed by the same patch as I just
sent in your other kernel NULL pointer dereference thread.

Hugh
