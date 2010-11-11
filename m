Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0KKGSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:18:32 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35548 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0KKGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:18:31 -0500
Date: Thu, 11 Nov 2010 07:17:25 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Gamari <bgamari@gmail.com>, "acme@infradead.org" <acme@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/20] x86, mce: Add persistent MCE event
Message-ID: <20101111061725.GA19321@aftab>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
 <1288885016-18295-4-git-send-email-bp@amd64.org>
 <87lj50vq0s.fsf@gmail.com>
 <20101110222157.GA23945@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110222157.GA23945@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 05:21:57PM -0500, Ingo Molnar wrote:
> 
> * Ben Gamari <bgamari@gmail.com> wrote:
> 
> > On Thu,  4 Nov 2010 16:36:39 +0100, Borislav Petkov <bp@amd64.org> wrote:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > Add the necessary glue to enable the mce_record tracepoint on boot
> > > turning it into a persistent event. This exports the MCE buffer
> > > read-only to a userspace daemon which will hook into it through debugfs
> > > when booting is finished.
> > 
> > While MCE technically is a diagnostics service, do we want to start adding 
> > dependencies on debugfs in long-running, common-place daemons? I was under the 
> > impression we were to avoid using debugfs for anything other than values for 
> > one-off debugging.
> 
> See this current discussion thread on lkml:
> 
>    [RFC][PATCH] perf: sysfs type id
> 
> Events are being added to sysfs as we want to avoid the debugfs dependency.

Yep, event enumeration will land in /sysfs eventually but in this case
debugfs is used to export the buffers with the events recorded so far to
the daemon which mmaps them. And I remember also being mentioned that
debugfs will thus be always compiled in because of that.

In any case, we need some kind of a facility with which to export those
buffers for userspace to mmap. sysfs is clearly not that and debugfs is
what we currently use. I'm open for better suggestions though.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
