Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1K1Ukt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:40:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:57097 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab1K1Ukr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:40:47 -0500
Message-ID: <1322512522.23348.43.camel@pasglop>
Subject: Re: [RFC PATCH v2 1/4] cpuidle: (powerpc) Add cpu_idle_wait() to
 allow switching of idle routines
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 29 Nov 2011 07:35:22 +1100
In-Reply-To: <4ED36A37.3030409@linux.vnet.ibm.com>
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
	 <20111117112830.9191.1951.stgit@localhost6.localdomain6>
	 <1322434096.23348.6.camel@pasglop> <4ED36A37.3030409@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 16:32 +0530, Deepthi Dharwar wrote:

> > Additionally, I'm a bit worried (but maybe we already discussed that a
> > while back, I don't know) but cpu_idle_wait() has "wait" in the name,
> > which makes me think it might need to actually -wait- for all cpus to
> > have come out of the function.
> 
> cpu_idle_wait is used to ensure that all the CPUs discard old idle
> handler and update to new one.  Required while changing idle
> handler on SMP systems.
>
> > Now your implementation doesn't provide that guarantee. It might be
> > fine, I don't know, but if it is, you'd better document it well in the
> > comments surrounding the code, because as it is, all you do is shoot an
> > interrupt which will cause the target CPU to eventually come out of idle
> > some time in the future.
> 
> 
> I was hoping that sending an explicit reschedule to the cpus would
> do the trick but sure we can add some documentation around the code.

Well, the question is what guarantee do you expect. Sending a reschedule
IPI will take the other CPUs out of the actual sleep mode, but it will
be some time from there back to getting out of the handler function
(first back out of hypervisor etc...).

The code as you implemented it doesn't wait for that to happen. It might
be fine ... or not. I don't know what semantics you are after precisely.

Cheers,
Ben.


