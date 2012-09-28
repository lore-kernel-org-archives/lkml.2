Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2I1OOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:14:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:33339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209Ab2I1ON5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:13:57 -0400
Message-ID: <1348841585.3292.76.camel@twins>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
From: Peter Zijlstra <peterz@infradead.org>
To: habanero@linux.vnet.ibm.com
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Date: Fri, 28 Sep 2012 16:13:05 +0200
In-Reply-To: <1348832438.5551.5.camel@oc6622382223.ibm.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	 <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com>
	 <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com>
	 <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com>
	 <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com>
	 <50643745.6010202@linux.vnet.ibm.com> <506440AF.9080202@redhat.com>
	 <506537C7.9070909@linux.vnet.ibm.com>
	 <1348832438.5551.5.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 06:40 -0500, Andrew Theurer wrote:
> It will be interesting to see how this behaves with a very high lock
> activity in a guest.  Once the scheduler defers preemption, is it for
> a
> fixed amount of time, or does it know to cut the deferral short as
> soon
> as the lock depth is reduced [by x]? 

Since the locks live in a guest/userspace, we don't even know they're
held at all, let alone when state changes.

Also, afaik PLE simply exits the guest whenever you do a busy-wait,
there's no guarantee its due to a lock at all, we could be waiting for a
'virtual' hardware resource or whatnot.


