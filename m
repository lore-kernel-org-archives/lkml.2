Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1AJRIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:08:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:43223 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754359Ab1AJRIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:08:17 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19mEygndc9mv5ou+EN3O7XJAjX2ULs++/7e6DO3rs
	KMfgYQdpAq/VS0
Subject: Re: [BUG stable, 2.6.32.27] sched: delayed cleanup of user_struct
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110110141959.GA312@redhat.com>
References: <4D2AB8F7.7030506@profihost.ag>
	 <20110110114913.GA22298@redhat.com> <20110110123630.GA27057@redhat.com>
	 <4D2AFFB5.5000807@profihost.ag> <20110110133545.GA30163@redhat.com>
	 <4D2B113A.2060303@profihost.ag> <20110110140817.GA31708@redhat.com>
	 <4D2B1658.20201@profihost.ag>  <20110110141959.GA312@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 18:07:50 +0100
Message-ID: <1294679270.8345.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 15:19 +0100, Oleg Nesterov wrote:
> On 01/10, Stefan Priebe - Profihost AG wrote:
> >
> >>> You can find the logs here:
> >>> http://pastebin.com/hNd15E8K
> >>
> >> Good. Sadly, I didn't see this trace before...
> >>
> >> 	kernel BUG at kernel/workqueue.c:287!
> >>
> >> this matches "INIT_DELAYED_WORK() can corrupt the pending work" I
> >> mentioned.
> > Sorry to ask this but this could also be "workarounded" by disabled
> > GROUP_SCHED? Or is this another thing?
> 
> Yes, this looks like the same thing.
> 
> But let me repeat, today I looked at this code for the first time ;)
> 
> > Will wait if greg or anybody else can tell
> > us something about it.
> 
> Indeed.

I'd be inclined to just shoot USER_SCHED, since it's dead upstream.  I'm
putting a small backport series together, and could add that to the mix.

	-Mike

