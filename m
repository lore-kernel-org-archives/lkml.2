Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0KKNfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:35:52 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51715 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab0KKNfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:35:51 -0500
Date: Thu, 11 Nov 2010 14:34:42 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Gamari <bgamari@gmail.com>, "acme@infradead.org" <acme@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 03/20] x86, mce: Add persistent MCE event
Message-ID: <20101111133442.GA21803@aftab>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
 <1288885016-18295-4-git-send-email-bp@amd64.org>
 <87lj50vq0s.fsf@gmail.com>
 <20101110222157.GA23945@elte.hu>
 <20101111061725.GA19321@aftab>
 <20101111085825.GB18789@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111085825.GB18789@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 03:58:25AM -0500, Ingo Molnar wrote:
> > Yep, event enumeration will land in /sysfs eventually but in this case debugfs is 
> > used to export the buffers with the events recorded so far to the daemon which 
> > mmaps them. And I remember also being mentioned that debugfs will thus be always 
> > compiled in because of that.
> 
> The event ring-buffer can be mmap()-ed off the fd that sys_perf_event_open() gives.

This is what I did in the first version of the patchset...

> This is what all of tools/perf/ does - it uses debugfs only for even enumeration
> (which will move to sysfs).

but then PeterZ suggested I should use debugfs to export the buffers
and not teach sys_perf_event_open of persistent events. Which is also
the right thing to do (maybe not through debugfs) since we want to have
a single per-cpu buffer with all MCEs in there which even multiple
userspace tools can access. So the question is, how do I mmap() those
properly?

So we either

1) use the perf syscall and teach it about persistent events and it always
returns the same fd whenever a persistent event is requested over its attr
argument;

2) use debugfs (current approach);

3) enable the persistent event and stash its fd in some /sysfs member
which the RAS daemon reads out and mmaps. This last one actually sounds
pretty neat.

4) another idea which I'm missing.

So what do you guys think?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
