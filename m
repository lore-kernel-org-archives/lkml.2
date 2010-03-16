Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937607Ab0CPJsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:48:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab0CPJsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:48:23 -0400
Date: Tue, 16 Mar 2010 10:47:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316094758.GH7961@elte.hu>
References: <1268717232.2813.36.camel@localhost>
 <4B9F19F7.6000309@redhat.com>
 <1268725724.2813.48.camel@localhost>
 <1268731733.2813.54.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268731733.2813.54.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> On Tue, 2010-03-16 at 15:48 +0800, Zhang, Yanmin wrote:
> > On Tue, 2010-03-16 at 07:41 +0200, Avi Kivity wrote:
> > > On 03/16/2010 07:27 AM, Zhang, Yanmin wrote:
> > > > From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
> > > >
> > > > Based on the discussion in KVM community, I worked out the patch to support
> > > > perf to collect guest os statistics from host side. This patch is implemented
> > > > with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
> > > > critical bug and provided good suggestions with other guys. I really appreciate
> > > > their kind help.
> > > >
> > > > The patch adds new subcommand kvm to perf.
> > > >
> > > >    perf kvm top
> > > >    perf kvm record
> > > >    perf kvm report
> > > >    perf kvm diff
> > > >
> > > > The new perf could profile guest os kernel except guest os user space, but it
> > > > could summarize guest os user space utilization per guest os.
> > > >
> > > > Below are some examples.
> > > > 1) perf kvm top
> > > > [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
> > > > --guestmodules=/home/ymzhang/guest/modules top
> > > >
> > > >    
> > > 
> > Thanks for your kind comments.
> > 
> > > Excellent, support for guest kernel != host kernel is critical (I can't 
> > > remember the last time I ran same kernels).
> > > 
> > > How would we support multiple guests with different kernels?
> > With the patch, 'perf kvm report --sort pid" could show
> > summary statistics for all guest os instances. Then, use
> > parameter --pid of 'perf kvm record' to collect single problematic instance data.
> Sorry. I found currently --pid isn't process but a thread (main thread).
> 
> Ingo,
> 
> Is it possible to support a new parameter or extend --inherit, so 'perf 
> record' and 'perf top' could collect data on all threads of a process when 
> the process is running?
> 
> If not, I need add a new ugly parameter which is similar to --pid to filter 
> out process data in userspace.

Yeah. For maximum utility i'd suggest to extend --pid to include this, and 
introduce --tid for the previous, limited-to-a-single-task functionality.

Most users would expect --pid to work like a 'late attach' - i.e. to work like 
strace -f or like a gdb attach.

	Ingo
