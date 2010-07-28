Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0G1Ozc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:55:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41421 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0G1Ozb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:55:31 -0400
Date: Wed, 28 Jul 2010 20:25:16 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: avi@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 2/4] Add yield hypercall for KVM guests
Message-ID: <20100728145516.GB27739@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20100726061150.GB21699@linux.vnet.ibm.com>
 <20100726061445.GB8402@linux.vnet.ibm.com>
 <4C4DC3AD.7010404@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4DC3AD.7010404@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 10:19:41AM -0700, Jeremy Fitzhardinge wrote:
>  On 07/25/2010 11:14 PM, Srivatsa Vaddagiri wrote:
> >Add KVM hypercall for yielding vcpu timeslice.
> 
> Can you do a directed yield?

We don't have that support yet in Linux scheduler. Also I feel it would be more
useful when the target vcpu and yielding vcpu are on the same physical cpu,
rather than when they are on separate cpus. With latter, yielding (or
donating) timeslice need not ensure that target vcpu runs immediately 
and also I suspect fairness issues needs to be tackled as well (large number of
waiters shouldn't boot a lock-holders time slice too much that it gets a 
larger share).

- vatsa
