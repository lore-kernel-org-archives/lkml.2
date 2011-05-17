Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1EQJXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:23:46 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:38920
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401Ab1EQJXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:23:44 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz936eK9371O1432N98dKzz1202hzz8275eh8275dha1495iz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLC239-02-0TM-02
X-M-MSG: 
Date: Tue, 17 May 2011 11:23:31 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Hillf Danton <dhillf@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
Message-ID: <20110517092331.GB22019@alberich.amd.com>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
 <1305016329.2914.22.camel@laptop>
 <BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
 <1305122055.2914.220.camel@laptop>
 <BANLkTikCF8uTH05gGG_H2bEYvZe0wmtS9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTikCF8uTH05gGG_H2bEYvZe0wmtS9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 01:50:42AM -0400, Hillf Danton wrote:
> On Wed, May 11, 2011 at 9:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2011-05-11 at 21:26 +0800, Hillf Danton wrote:
> >> Your work for rewriting NUMA support, published at
> >>          http://marc.info/?l=linux-kernel&m=130218515520540
> >> is patched by changing how level is computed and by changing how it is
> >> used to build the mask.
> >>
> >> When computing, some valid levels are lost in your work.
> >>
> >> When building mask, nodes are selected only if they have same distance,
> >> thus nodes of less distance are also masked out since the computation of
> >> level now is tough.
> >>
> >> Without MUNA hardware, I did not test the patch:(
> >
> > I do have a (tiny) NUMA box (2 nodes) but that actually booted with the
> > old code too, Andreas Hermann from AMD (CC'ed) is usually willing to
> > test such patches on somewhat larger systems. Please send a full patch
> > against tip/master for him to apply.
> >
> 
> Hi Peter
> 
> With the guiding from Ingo on git fetch the tip/master, the work is
> now finished:)
> 
> Hopely it is not too late for Andreas.
> 
> In the following, the concern is also added for distances not covered by level,
> please review again.

Sorry, can't test your stuff. What git-tree and branch did you use to
build this patch?

Your patch seems to be corrupted/broken:

  # scripts/checkpatch.pl your_patch.diff 
  ERROR: patch seems to be corrupt (line wrapped?)
  #175: FILE: kernel/sched.c:6822:
  *(*sched_domain_mask_f)(int cpu);
  
  WARNING: line over 80 characters
  #222: FILE: kernel/sched.c:7088:
  +     return per_cpu_ptr(sched_domains_numa_masks[sched_domains_curr_level], cpu);
  
  WARNING: printk() should include KERN_ facility level
  #239: FILE: kernel/sched.c:7105:
  +     	    printk("distance(0,%d): %d\n", j, distance);
  
  ERROR: need consistent spacing around '-' (ctx:WxV)
  #253: FILE: kernel/sched.c:7119:
  +     	    for (k = level -1; k >= i; k--)
 	    	               ^
  ...

(I assume that it wasn't corrupted on my end.)


Andreas


