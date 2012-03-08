Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2CHLzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:55:32 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47981 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab2CHLz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:55:29 -0500
Date: Thu, 8 Mar 2012 17:25:06 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland Dreier <roland@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: runnable tasks never making it to a runqueue where they can run?
Message-ID: <20120308115506.GA22656@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
 <1331137905.11248.355.camel@twins>
 <CAG4TOxM2yGvFo5O9x0M6H2GONPyF9XVOLwonfS-1gkpskkO+0w@mail.gmail.com>
 <1331202480.11248.375.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1331202480.11248.375.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030811-4790-0000-0000-000001B1545F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-03-08 11:28:00]:

> select_task_rq_fair() will very likely end up in select_idle_sibling()
> which will never select the smt1 if smt0 is idle

s/idle/busy?

> (even if smt0 isn't in
> the cpus allowed mask) -- Vatsa is currently reworking that area, this
> is something he might want to consider.

The patch I sent couple of days back should likely fix this issue:

http://marc.info/?l=linux-kernel&m=133096114129607&w=2

- vatsa

