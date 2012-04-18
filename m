Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2DRPcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:32:21 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:35551 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2DRPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:32:18 -0400
Date: Wed, 18 Apr 2012 15:33:12 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Doug Ledford <dledford@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [Patch 5/8] mqueue: revert bump up DFLT_*MAX
Message-ID: <20120418153312.GE24399@mail.hallyn.com>
References: <cover.1334676645.git.dledford@redhat.com>
 <de8d761688dd34f312822db71ceed6753493933a.1334676645.git.dledford@redhat.com>
 <20120418032210.GB18830@mail.hallyn.com>
 <4F8ECED3.5070909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8ECED3.5070909@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Doug Ledford (dledford@redhat.com):
> On 4/17/2012 11:22 PM, Serge E. Hallyn wrote:
> > Quoting Doug Ledford (dledford@redhat.com):
> >> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >>
> >> Mqueue limitation is slightly naieve parameter likes other ipcs
> >> because unprivileged user can consume kernel memory by using ipcs.
> >>
> >> Thus, too aggressive raise bring us security issue. Example,
> >> current setting allow evil unprivileged user use 256GB (= 256
> >> * 1024 * 1024*1024) and it's enough large to system will belome
> >> unresponsive. Don't do that.
> >>
> >> Instead, every admin should adjust the knobs for their own systems.
> > 
> > Would you be terribly averse to having a higher limit in init_ipc_ns,
> > and the lower values by default in all child namespaces?
> > 
> > Sorry it sounds from the intro like you've already had quite a bit of
> > discussion on this...
> > 
> > Of course I realize the values can just be raised by distro boot
> > scripts...
> 
> The default maximums this patch put into place were in fact in place
> from 2008 until my earlier patch in this same series, so in that regard
> this is merely restoring an already established default maximum.  It

Then never mind :)

(My ack stands)

> *could* be raised, yes, but as Motohiro pointed out, this is pinned
> memory that any user can allocate, so the smaller the default amount the
> better.  The sysadmin can make changes as they see fit.

Thanks,
-serge
