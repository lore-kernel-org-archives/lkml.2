Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1HQSaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:30:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1HQSaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:30:24 -0400
Date: Wed, 17 Aug 2011 20:26:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kthreads: allow_signal: don't play with ->blocked
Message-ID: <20110817182658.GA26946@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-42-git-send-email-matt@console-pimps.org> <20110816180644.GJ29190@redhat.com> <20110816194427.GA6602@redhat.com> <20110816194450.GB6602@redhat.com> <20110816195121.GG2803@mtj.dyndns.org> <1313531422.3436.218.camel@mfleming-mobl1.ger.corp.intel.com> <20110817072746.GI4254@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817072746.GI4254@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Tejun Heo wrote:
>
> On Tue, Aug 16, 2011 at 10:50:22PM +0100, Matt Fleming wrote:
> > On Tue, 2011-08-16 at 21:51 +0200, Tejun Heo wrote:
> > > I agree with the patchset but given that daemonize() isn't all that
> > > popular and you already posted most (or was it all?) conversions,

Yes, with the patches I sent daemonize() has no callers.

> but in this case it's an interface which is
> quite unpopular and with relatively easy workaround (just use
> kthread).

Agreed.

> The worst thing we can do regarding API change is silently changing
> semantics while not changing the interface.
> ...
> Out-of-kernel user which depended on the combination working would now
> be left with code which compiles fine but behaves differently, which
> sucks big time.

Yes, this is of course possible.

> So, let's please collect all the
> related patches into one series,

This is what I can't understand ;) This connects to your
"How do you wanna route these" question in another thread.

> drop all in-kernel daemonize() users,
> kill daemonize() and then change allow_signal() behavior.

OK, if we kill daemonize() without the deprecation stage, this is fine.

Initially I assumed it won't go away soon, and this sigdelset()
is really nasty although minor.

Oleg.

