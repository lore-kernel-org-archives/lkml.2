Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1KQB7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:59:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53668 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754749Ab1KQB7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:59:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+0dI8845u0kC4A3TMUVRt9OZNG0D4iadzu4/ukKu
	Bq0iNSt/skKxd0
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 02:59:13 +0100
Message-ID: <1321495153.5100.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 10:37 -0800, Suresh Siddha wrote:
> On Wed, 2011-11-16 at 01:24 -0800, Mike Galbraith wrote:

> > At SIBLING, group = 0,4 = 0x5, 0x5 & 0xff = 1 = target.
> 
> Mike, At the sibling level, domain span will be 0,4 which is 0x5. But
> there are two individual groups. First group just contains cpu0 and the
> second group contains cpu4.
> 
> So if cpu0 is busy, we will check the next group to see if it is idle
> (which is cpu4 in your example). So we will return cpu-4.

Oh duh, right.

> It should be ok. Isn't it?

Nope, wasn't ok.  I'll double check today though, and bend, spindle
and/or mutilate as required.

	-Mike

