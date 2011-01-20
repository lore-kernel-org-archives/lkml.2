Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1ATE2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:28:18 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40950 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab1ATE2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:28:17 -0500
Date: Thu, 20 Jan 2011 09:58:12 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        suzuki@in.ibm.com
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
Message-ID: <20110120042811.GA17034@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110117152222.GA19233@linux.vnet.ibm.com>
 <4D372DEA.1060004@goop.org>
 <20110119183914.GB7235@linux.vnet.ibm.com>
 <4D37338E.8030509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D37338E.8030509@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:55:10AM -0800, Jeremy Fitzhardinge wrote:
> On 01/19/2011 10:39 AM, Srivatsa Vaddagiri wrote:
> > I have tested quite extensively with booting a 16-vcpu guest (on a 16-pcpu host)
> > and running kernel compine (with 32-threads). Without this patch, I had
> > difficulty booting/shutting-down successfully (it would hang mid-way).
> 
> Sounds good.  But I like to test with "make -j 100-200" to really give
> things a workout.

I reran the tests with the following configuration:

Host : 16pcpus, 32GB Memory
Single KVM guest w/ 32vcpus, 16GB memory

It survived a kernel compile with 200 threads once and another time with 300
threads. 'make allyesconfig' was run before compiling the kernel. So looks
quite stable to me ..additional testing from wider community will also help.

- vasa
