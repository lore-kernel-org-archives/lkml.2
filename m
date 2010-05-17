Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0EQSif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:38:35 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:50222 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0EQSid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:38:33 -0400
Date: Mon, 17 May 2010 21:39:05 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Brian Swetland <swetland@google.com>
Cc: me@felipebalbi.com, James Bottomley <James.Bottomley@suse.de>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100517183904.GA14047@gandalf>
Reply-To: me@felipebalbi.com
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
 <87hbm6cz90.fsf@deeprootsystems.com>
 <1274115885.4418.59.camel@mulgrave.site>
 <20100517174647.GA11512@gandalf>
 <1274119179.4418.68.camel@mulgrave.site>
 <20100517181252.GA14260@gandalf>
 <AANLkTikueXPEWEHQt-Fl3Xvb3EB4ntsBlJUjjtmpinGK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikueXPEWEHQt-Fl3Xvb3EB4ntsBlJUjjtmpinGK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 17, 2010 at 11:26:59AM -0700, Brian Swetland wrote:
> We (Google) would like to allow completely open app distribution with
> minimal hurdles, and avoid the walled garden approach.  Toward this
> goal we're not even requiring the use of a central app store for
> distribution.

I understand that, but still we should be telling developers what
they're doing wrong so that they can improve themselves as professionals
and still make the final device better.

> Obviously, given the ability to run *any* app, users will run into bad
> (or perhaps just less-than-optimal-powerwise) apps.  Being able to
> provide the best possible battery life (in spite of
> sometimes-nonoptimal userspace apps) and simultaneously informing
> users about which apps are better/worse for their battery life is a
> goal here.

I see. Just hope MeeGo doesn't venture on the same waters :-s

> For a large majority of apps, running in the background while the
> device is asleep (screen off) is not essential, they don't request the
> "keep device awake" permission, never hold a wakelock, etc.  Those
> that do need to do this have the permission, may hold suspend
> blockers, and are accounted for.

but can anyone write an app that holds a suspend_blocker ?? If so, then
your goal is already broken, right ? I mean, if anyone can keep a
suspend_blocker held forever, you'll never ever sleep, right ? While
with runtime, if you keep the keypad open, only the keypad and the paths
directly related to it (probably the i2c controller and the power domain
where the i2c controller sits) will be kept alive, no ?

> Unrelated to apps, the ability to say "please enter suspend as soon as
> there's no more work (kernel or userspace) preventing it", in a
> simple, non-racy way is useful.

I just tend to agree with Kevin on questioning how different how
different this actually is from runtime_pm. I guess I would need to dig
through some documentation in order to understand but it seems really
similar.

-- 
balbi
