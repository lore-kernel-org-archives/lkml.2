Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1BCQu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:50:57 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:41535
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753287Ab1BCQu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:50:56 -0500
Date: Thu, 3 Feb 2011 16:51:32 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gergely Nagy <algernon@balabit.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110203165132.GA28172@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
 <20110203153252.GA24153@mail.hallyn.com>
 <1296748401.14846.39.camel@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296748401.14846.39.camel@moria>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gergely Nagy (algernon@balabit.hu):
> On Thu, 2011-02-03 at 15:32 +0000, Serge E. Hallyn wrote:
> > > Back in november, a patch was merged into the kernel (in  commit
> > > ce6ada35bdf710d16582cc4869c26722547e6f11), that splits CAP_SYSLOG out of
> > > CAP_SYS_ADMIN.
> > > 
> > > Sadly, this has an unwelcomed consequence, that any userspace syslogd
> > > that formerly used CAP_SYS_ADMIN will stop working, unless upgraded, or
> > > otherwise adapted to the change.
> > > 
> > > However, updating userspace isn't that easy, either, if one wants to
> > > support multiple kernels with the same userspace binary: pre-2.6.38, one
> > > needs CAP_SYS_ADMIN, but later kernels will need CAP_SYS_ADMIN. It would
> > > be trivial to keep both, but that kind of defeats the purpose of
> > > CAP_SYSLOG,
> > 
> > The idea would be to only use both when you detect a possibly older
> > kernel. 
> 
> I was considering that, but... how do I reliably detect an older kernel?
> So far, I didn't find a reliable way with which I can detect a kernel
> version at run-time (apart from parsing utsname)

...  Why not parse utsname?

>  - but it's entirely
> possible, that I missed something obvious.
> 
> Furthermore, this still needs an userspace upgrade aswell, so only helps
> one half of the problem.

True, that only addresses the less forgivable problem I introduced, namely
what does updated userspace even do to do the right thing.

> > However, you're right of course, I really should have provided some way
> > for userspace to click 'ok, got the message, now continue anyway because
> > I'm running older userspace for now,'  i.e. a sysctl perhaps.
> > 
> > Sorry about the trouble.  Here is a patch to just warn for now, with
> > the changelog showing what i intend to push next.
> > 
> > sorry again,
> > -serge
> > 
> > From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> > From: Serge Hallyn <serge@peq.(none)>
> > Date: Thu, 3 Feb 2011 09:26:15 -0600
> > Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
> > 
> > At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> > 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> > users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> > that they've seen the syslog message about cap_sys_admin being
> > deprecated for syslog.
> 
> Could we have it the other way around, at least for a while? Otherwise,

Sure.

So long as there is a definite path toward eventually having syslog
with CAP_SYS_ADMIN be denied.

> if someone happens to upgrade the kernel, and forgets to upgrade the
> syslogd, he'll still experience breakage. With defaulting to 1,
> compatiblity is kept, and systems that were upgraded properly can set it
> to 0 and live happily ever after. The WARNs should prompt people to
> upgrade at the first opportunity, so hopefully, it won't go unnoticed
> and ignored by userspace.
> 
> I'm not sure one would even see the kernel warn with the syslogd not
> being able to read the kernel messages (dmesg, of course, would reveal
> it, but that's one extra step).

-serge
