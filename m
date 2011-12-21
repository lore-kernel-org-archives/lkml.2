Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1LULqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:46:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1LULqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:46:31 -0500
Date: Wed, 21 Dec 2011 13:46:01 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>, Avi Kivity <avi@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111221114601.GA2446@redhat.com>
References: <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <4EF05996.8030807@redhat.com>
 <20111220100916.GA20788@elte.hu>
 <20111220152758.GA30127@8bytes.org>
 <20111220184004.GE8408@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220184004.GE8408@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 07:40:04PM +0100, Ingo Molnar wrote:
> > The point is, if user-space re-programs LWP it will continue 
> > to write its samples to the new ring-buffer virtual-address 
> > set up by user-space. It will still use that virtual address 
> > in another address-space after a task-switch. This allows 
> > processes to corrupt memory of other processes. [...]
> 
> That's nonsense. As i said it my previous mail the LWPC should 
> be per task and switched on task switch - just like the DS/PEBS 
> context is.
> 
Is it? Looking at arch/x86/kernel/cpu/perf_event_intel_ds.c it seems
like DS is per cpu, not per task.

--
			Gleb.
