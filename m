Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1ECPmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:42:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56892 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1ECPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:42:49 -0400
Date: Tue, 3 May 2011 17:42:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 3/4] x86, mce: Add persistent MCE event
Message-ID: <20110503154215.GH20241@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-4-git-send-email-bp@amd64.org>
 <20110503064401.GE7751@elte.hu>
 <20110503071833.GB18979@aftab>
 <1304435656.1788.8.camel@Joe-Laptop>
 <20110503152224.GG20241@aftab>
 <1304436872.25414.2403.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304436872.25414.2403.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:34:32AM -0400, Steven Rostedt wrote:
> On Tue, 2011-05-03 at 17:22 +0200, Borislav Petkov wrote:
> > On Tue, May 03, 2011 at 11:14:16AM -0400, Joe Perches wrote:
> > > On Tue, 2011-05-03 at 09:18 +0200, Borislav Petkov wrote:
> > > > On Tue, May 03, 2011 at 02:44:01AM -0400, Ingo Molnar wrote:
> > > > > * Borislav Petkov <bp@amd64.org> wrote:
> > > []
> > > > > > +static struct dentry *mce_add_event_debugfs(struct perf_event *event, int cpu)
> > > > > > +{
> > > > > > +	char buf[14];
> 
> There should be no harm in upping that number to 32. (I've seen much
> worse on stacks).
> 
> > > > > > +
> > > > > > +	sprintf(buf, "mce_record%d", cpu);
> 
> At least change this to:
> 
> 		snprintf(buf, 14, ....)

Yep, this is the only sane suggestion I've got, thanks.

Other than that, we shouldn't be concentrating too much on this since
we're moving to /sysfs anyway and there we have the per-CPU hierarchy
with /sys/devices/system/cpu/cpu%d...

> > I'll fix that when someone comes up with a x86 system that supports 10k+
> > CPUs with a single system image :).
> > 
> 
> Best to fix it now, to save the trouble of finding this bug for those
> that are maintaining this code long after we have retired or are dead ;)

Nah, I'll leave it in so that they can have a blast from the past and
can boast on the slashdot of the future or on ((LWN++)..)++ that they've
fixed the oldest bug in Linux when booting it on quantum x86 computers
and tried running their RAS daemon :-).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
