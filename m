Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0ECVuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:50:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37295 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0ECVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:50:51 -0400
Date: Mon, 3 May 2010 22:50:28 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100503215028.GB18910@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wrvl5479.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:40:26AM -0700, Kevin Hilman wrote:

> In my view, the truly significant difference between suspend blockers
> and runtime PM is what happens to userspace.  So far, to me the only
> compelling argument for suspend blockers is the goal of forcibly
> shutting down userspace and thus forcing the system into idle
> (although drivers could still reject a suspend request.)

I'd say that this is certainly the main issue, though the remaining 
periodic timers in the kernel are also inconvenient.

> And if untrusted userspace apps remain as the major problem, maybe we
> should aim for a solution directly targetting that problem.  I'm just
> shooting from the hip now, but maybe containing (cgroups?) untrusted
> processes together into a set that could be frozen/idled so that runtime PM
> would be more effective would be a workable solution?

I considered this. The problem is that not all of your wakeup events 
pass through trusted code. Assume we've used a freezer cgroup and the 
applications are now frozen. One of them is blocking on a network 
socket. A packet arrives and triggers a wakeup of the hardware. How do 
we unfreeze the userspace app?

I agree that the runtime scenario is a far more appealing one from an 
aesthetic standpoint, but so far we don't have a very compelling 
argument for dealing with the starting and stopping of userspace. The 
use-cases that Google have provided are valid and they have an 
implementation that addresses them, and while we're unable to provide an 
alternative that provides the same level of functionality I think we're 
in a poor position to prevent this from going in.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
