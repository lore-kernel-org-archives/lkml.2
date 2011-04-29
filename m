Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab1D2Tc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:32:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33173 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543Ab1D2Tc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 15:32:57 -0400
Date: Fri, 29 Apr 2011 21:32:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110429193237.GB15068@elte.hu>
References: <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu>
 <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
 <20110426073847.GB30630@elte.hu>
 <alpine.DEB.2.00.1104261648400.32482@cl320.eecs.utk.edu>
 <20110427065241.GF17079@elte.hu>
 <alpine.DEB.2.00.1104281811400.25779@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104281811400.25779@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Wed, 27 Apr 2011, Ingo Molnar wrote:
> 
> > Secondly, you are still quite wrong even with your revised opinion. Being able 
> > to type '-e cycles' and '-e instructions' in perf and get ... cycles and 
> > instructions counts/events, and the kernel helping that kind of approach is not 
> > 'abstraction to the extreme', it's called 'common sense'.
> 
> by your logic I should be able to delete a file by saying
>
>   echo "delete /tmp/tempfile" > /dev/sdc1

> because using unlink() is too low of an abstraction and confusing to the 
> user.

Erm, unlink() does not pass magic hexa constants to the disk controller.

unlink() is a high level interface that works across a vast range of disk 
controllers, disks, network mounted filesystems, in-RAM filesystems, in-ROM 
filesystems, clustered filesystems and other mediums.

Just like that we can tell perf to count 'cycles', 'branches' or 
'branch-misses' - all of these are relatively high level concepts (in the scope 
of CPUs) that work across a vast range of CPU types and models.

Similarly, for offcore we want to introduce the concept of 'node local' versus 
'remote' memory - perhaps with some events for inter-CPU traffic as well - 
because that probably covers most of the NUMA related memory profiling needs.

Raw events are to perf what ioctls are to the VFS: small details nobody felt 
worth generalizing. My point in this discussion is that we do not offer new 
filesystems that support *only* ioctl calls ... Is this simple concept so hard 
to understand?

Thanks,

	Ingo
