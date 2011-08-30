Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1H3Vot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:44:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab1H3Vos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:44:48 -0400
Date: Tue, 30 Aug 2011 14:44:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] posix-timers: limit the number of posix timers per
 process
Message-Id: <20110830144407.acdae071.akpm@linux-foundation.org>
In-Reply-To: <1314661157-22173-2-git-send-email-andi@firstfloor.org>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
	<1314661157-22173-2-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 16:39:15 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> Now this is the main reason I wrote the whole patchkit: previously
> there was no limit on the maximum number of POSIX timers a process
> could allocate.  This limits the amount of unswappable kernel memory
> a process can pin down this way.
> 
> With the POSIX timer ids being per process we can do this limit
> per process now without allowing one process DoSing another.
> 
> I implemented it as a sysctl, not a rlimit for now, because
> there was no clear use case for rlimit.
> 
> The 1024 default is completely arbitrary, but seems reasonable
> for now.

Sorry, it should be an rlimit from day one, IMO.

Partly because rlimits are a better implementation.

Partly because if we later do it via rlimit, we're stuck having to
maintain the /proc knob for ever.

Partly because once rlimits are added, the /proc knob no longer has any
sane behaviour.  Does it only modify /sbin/init?  Does it do a global
process walk, modifying all threads?
