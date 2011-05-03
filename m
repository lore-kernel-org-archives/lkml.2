Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1ECTwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:52:36 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47665 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1ECTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:52:34 -0400
Date: Tue, 3 May 2011 21:52:00 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110503195200.GA23243@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 01:17:50PM -0400, Luck, Tony wrote:
> > Ok, the problem I see with it is that people without a RAS daemon
> > running will have the mechanism collecting MCEs in the background, using
> > up resources (4 pages per CPU is the buffer) and not doing anything (in
> > the best case that is, when we're not broken otherwise).
> 
> Can the kernel detect whether anyone is listening to the
> persistent MCE event?  If so, then the kernel could printk()
> something to let the user with no RAS daemon (or a dead
> daemon) that stuff is happening that they might like to
> know about.

Right, so I have a primitive way to do that when you enable ras over the
command line, i.e. boot with "ras=on." But that doesn't help in cases
where the daemon dies for some reason.

Maybe the decoding path should look at whether the event descriptor is
still mmapped or whether the event is enabled; let me think about it a
bit longer, good point btw!

> Probably make some sense to delay such a message (so that in
> the boot case we give the daemon a chance to get started before
> complaining that it hasn't shown up for work).

Yep, that and also I need to address the case for catching earlybird
MCEs, when perf hasn't been initialized yet. I'm thinking we could
reuse the mcelog buffer and feed those into the RAS daemon after init.
Something like that.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
