Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab1ECHXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:23:36 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42461 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1ECHXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:23:34 -0400
Date: Tue, 3 May 2011 09:23:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110503072302.GC18979@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503064505.GF7751@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 02:45:05AM -0400, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > This is new functionality and it affects all of x86 so we want to be
> > very conservative about it and have it off by default for now, in case
> > something goes awry. You can always enable it by supplying "ras" on the
> > kernel command line.
> > 
> > Also, depending on whether it is enabled or not, we emit the tracepoint
> > from a different place in the code to pick up additional decoded info.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  Documentation/kernel-parameters.txt |    2 ++
> >  arch/x86/include/asm/mce.h          |    1 +
> >  arch/x86/kernel/cpu/mcheck/mce.c    |   32 ++++++++++++++++++++++++++++++--
> >  drivers/edac/mce_amd.c              |    5 +++++
> >  4 files changed, 38 insertions(+), 2 deletions(-)
> 
> the boot flag is fine - but please keep it enabled by default if MCE support is 
> enabled in the .config, we do not chicken out when it comes to testing new 
> code! :-)

Ok, the problem I see with it is that people without a RAS daemon
running will have the mechanism collecting MCEs in the background, using
up resources (4 pages per CPU is the buffer) and not doing anything (in
the best case that is, when we're not broken otherwise).

Do we want to have that on all x86 turned on by default? Or maybe invert
the flag semantics so that people can disable it on boot?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
