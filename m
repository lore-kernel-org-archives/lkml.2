Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569Ab2EPUAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:00:11 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59357 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965477Ab2EPUAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:00:08 -0400
Date: Wed, 16 May 2012 21:59:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Message-ID: <20120516195951.GA5326@aftab.osrc.amd.com>
References: <20120514133404.GE4231@aftab.osrc.amd.com>
 <4FB1163D.3010302@redhat.com>
 <20120515150957.GC27806@aftab.osrc.amd.com>
 <4FB27EDC.8040001@redhat.com>
 <20120515163855.GE27806@aftab.osrc.amd.com>
 <4FB38DDF.7030009@redhat.com>
 <20120516131656.GA2202@aftab.osrc.amd.com>
 <4FB3C4D3.7000802@redhat.com>
 <20120516154708.GC2202@aftab.osrc.amd.com>
 <4FB3DB45.4060101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3DB45.4060101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 01:52:21PM -0300, Mauro Carvalho Chehab wrote:
> Em 16-05-2012 12:47, Borislav Petkov escreveu:
> > On Wed, May 16, 2012 at 12:16:35PM -0300, Mauro Carvalho Chehab wrote:
> >>> This doesn't answer my question. My question was: "why can't 'detail'
> >>> and 'driver_detail' be a single parameter, i.e. 'detail' and this way
> >>> solve both pretty printing and getting binary data problems?
> >>
> >> This is the 24th version of this very same patch...
> > 
> > This would have been the case if you'd split your patches and sent them
> > in 10-15 patches sets like normal people, _after_ gathering all review feedback.
> 
> The first version had only 3 patches. Patches were being added there due to
> the huge delay to get them reviewed/accepted.
> 
> > But, you wanted to fix EDAC and the whole world while at it and besides,
> > your patches caused boot errors here and there.
> > 
> > Then, you went and rebased the whole patchset after me reviewing one or
> > two and incremented for that rebase the version number.
> 
> Because you requested that by not accepting incremental patches at the end
> of the series.

No, because this is how patch series are done. Incremental patches are
for people who get paid on the amount of patches they get into the
kernel.

> > So v24 means nothing to me - you might just as well use it for your
> > internal tracking.
> > 
> >> In summary: all edac messages provide "detail" as this contains the
> >> error location in terms of channel/slot. So, any MIB for EDAC could
> >> handle those parameters properly. With regards to driver_detail, this
> >> have per-driver details. So, per-driver MIB is required for them, if
> >> some userspace program wants to properly store that information.
> >>
> >> Merging those two separate fields together only makes harder for
> >> userspace to store the error detail information on their MIB.
> > 
> > There's that MIB crap again.
> > 
> > And it doesn't make it harder for anything because in userspace you can
> > do everything with those strings, cut them, replace them, whatever your
> > heart desires, even store the correct error detail information "on their
> > MIB." Basically, you have one string in userspace and you can massage
> > the hell out of it and even fit it to the MIB or whatever...
> 
> The rationale behind providing binary information instead of a printk is
> to avoid kernel to spend time with printk formatting and userspace to
> parse it and try to recover the original data.
> 
> If this weren't a requirement, the better would be to just not use any 
> tracepoint for errors at all.
> 
> Also, the API should be handled in a way that it will work on userspace.

No, userspace will be doing parsing because it is the only sensible
thing to do. The kernel's job is to carry out enough information for
the user to handle the error in a way which is just enough. No more, no
less. It is in no f*cking way expected to make it pretty and in suitable
portions so that userspace can consume it.

Ok, this took longer than I thought and I'm getting really tired of the
crap so let me save you the trouble:

* either make the RAS tracepoint patch the way I'm suggesting.

* or give a really good reason for doing it differently (and yes,
userspace will be doing parsing).

* or consider it nacked.

It is that simple.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
