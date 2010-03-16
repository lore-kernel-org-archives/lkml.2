Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966057Ab0CPJ2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:28:52 -0400
Received: from mga07.intel.com ([143.182.124.22]:52688 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965516Ab0CPJ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:28:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,649,1262592000"; 
   d="scan'208";a="500986030"
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
In-Reply-To: <1268725724.2813.48.camel@localhost>
References: <1268717232.2813.36.camel@localhost>
	 <4B9F19F7.6000309@redhat.com>  <1268725724.2813.48.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 16 Mar 2010 17:28:53 +0800
Message-Id: <1268731733.2813.54.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 15:48 +0800, Zhang, Yanmin wrote:
> On Tue, 2010-03-16 at 07:41 +0200, Avi Kivity wrote:
> > On 03/16/2010 07:27 AM, Zhang, Yanmin wrote:
> > > From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
> > >
> > > Based on the discussion in KVM community, I worked out the patch to support
> > > perf to collect guest os statistics from host side. This patch is implemented
> > > with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
> > > critical bug and provided good suggestions with other guys. I really appreciate
> > > their kind help.
> > >
> > > The patch adds new subcommand kvm to perf.
> > >
> > >    perf kvm top
> > >    perf kvm record
> > >    perf kvm report
> > >    perf kvm diff
> > >
> > > The new perf could profile guest os kernel except guest os user space, but it
> > > could summarize guest os user space utilization per guest os.
> > >
> > > Below are some examples.
> > > 1) perf kvm top
> > > [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
> > > --guestmodules=/home/ymzhang/guest/modules top
> > >
> > >    
> > 
> Thanks for your kind comments.
> 
> > Excellent, support for guest kernel != host kernel is critical (I can't 
> > remember the last time I ran same kernels).
> > 
> > How would we support multiple guests with different kernels?
> With the patch, 'perf kvm report --sort pid" could show
> summary statistics for all guest os instances. Then, use
> parameter --pid of 'perf kvm record' to collect single problematic instance data.
Sorry. I found currently --pid isn't process but a thread (main thread).

Ingo,

Is it possible to support a new parameter or extend --inherit, so 'perf record' and
'perf top' could collect data on all threads of a process when the process is running?

If not, I need add a new ugly parameter which is similar to --pid to filter out process
data in userspace.

Yanmin


