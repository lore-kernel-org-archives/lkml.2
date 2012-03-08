Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2CHMAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:00:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:49207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2CHMAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:00:42 -0500
Message-ID: <1331208028.11248.384.camel@twins>
Subject: Re: runnable tasks never making it to a runqueue where they can run?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Roland Dreier <roland@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 08 Mar 2012 13:00:28 +0100
In-Reply-To: <20120308115506.GA22656@linux.vnet.ibm.com>
References: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
	 <1331137905.11248.355.camel@twins>
	 <CAG4TOxM2yGvFo5O9x0M6H2GONPyF9XVOLwonfS-1gkpskkO+0w@mail.gmail.com>
	 <1331202480.11248.375.camel@twins>
	 <20120308115506.GA22656@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 17:25 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-03-08 11:28:00]:
> 
> > select_task_rq_fair() will very likely end up in select_idle_sibling()
> > which will never select the smt1 if smt0 is idle
> 
> s/idle/busy?

Uhm, yeah ;-)

> > (even if smt0 isn't in
> > the cpus allowed mask) -- Vatsa is currently reworking that area, this
> > is something he might want to consider.
> 
> The patch I sent couple of days back should likely fix this issue:
> 
> http://marc.info/?l=linux-kernel&m=133096114129607&w=2

Ah, thanks for reminding me, I need to go stare at that!
