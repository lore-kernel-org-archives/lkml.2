Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0LCRpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:45:42 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42588 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab0LCRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:45:40 -0500
Date: Fri, 3 Dec 2010 23:15:34 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
Message-ID: <20101203174534.GD11725@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1291355656.7633.124.camel@marge.simson.net>
 <20101203134618.GG27994@linux.vnet.ibm.com>
 <1291387511.7992.15.camel@marge.simson.net>
 <4CF90341.4020101@redhat.com>
 <1291388987.7992.27.camel@marge.simson.net>
 <4CF90E3D.7090103@redhat.com>
 <20101203162003.GA13515@linux.vnet.ibm.com>
 <4CF9242D.4090007@redhat.com>
 <20101203172954.GC11725@linux.vnet.ibm.com>
 <4CF929E9.6000603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF929E9.6000603@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 12:33:29PM -0500, Rik van Riel wrote:
> >Anyway, the intention of yield() proposed was not to get lock released
> >immediately (which will happen eventually), but rather to avoid inefficiency
> >associated with (long) spinning and at the same time make sure we are not
> >leaking our bandwidth to other guests because of a naive yield ..
> 
> A KVM guest can run on the host alongside short-lived
> processes, though.  How can we ensure that a VCPU that
> donates time gets it back again later, when the task
> time was donated to may no longer exist?

I think that does not matter. What matters for fairness in this case is how much
cpu time yielding thread gets over some (larger) time window. By ensuring that
relinquished time is fedback, we should maintian fairness for that particular
vcpu thread ..This also avoids nasty interactions associated with donation ..

- vatsa
