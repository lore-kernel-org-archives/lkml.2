Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab2AKRUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:20:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62410 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2AKRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:19:58 -0500
Date: Wed, 11 Jan 2012 09:19:51 -0800
From: "tj@kernel.org" <tj@kernel.org>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@gentwo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/3] Code clean up for percpu_xxx() functions
Message-ID: <20120111171951.GF26832@google.com>
References: <1318428673.29699.13.camel@debian>
 <alpine.DEB.2.00.1110120910540.26610@router.home>
 <1318908091.23426.52.camel@debian>
 <alpine.DEB.2.00.1110180932330.687@router.home>
 <1319016218.23426.104.camel@debian>
 <alpine.DEB.2.00.1110191033480.24001@router.home>
 <1319096139.23426.184.camel@debian>
 <1321866612.30341.572.camel@debian>
 <20111122000653.GS25776@google.com>
 <1326272921.5695.263.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326272921.5695.263.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 05:08:41PM +0800, Alex,Shi wrote:
> On Mon, 2011-11-21 at 17:06 -0700, tj@kernel.org wrote:
> > (cc'ing hpa and quoting whole body)
> > > 
> > > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > > Acked-by: Christoph Lameter <cl@gentwo.org>
> > 
> >  Acked-by: Tejun Heo <tj@kernel.org>
> > 
> > hpa, I suppose this should go through x86?  The original patch can be
> > accessed at
> > 
> >   http://article.gmane.org/gmane.linux.kernel/1218055/raw
> 
> Rend for 3.2 kernel, no any change needed to apply on latest Linus'
> tree. :) 
> 
> Actually, this clean up has no performance or security impact for
> kernel. On the contrary, removing some potential redundant preempt
> disable will bring a slight performance benefit to kernel. 
> 
> This 3rd patch depends on previous 2 patches, the 2nd one kvm code clean
> up was submitted for 3.3 kernel. but the 2st one net code clean up is
> waiting for David's comments.

Alex, can you please collect all patches into a single patchset?
Please split it such that, usage changes are per-system so that they
can be routed through respective subsystems (x86 or net) and updates
to percpu proper which can be applied after other changes have been
applied.  It would probably be best to route these patches separately
rather than all through percpu as it touches a lot of different places
and is likely to cause conflicts.  I *think* the best way would be,

* Submit per-subsystem patches and get them merged to subsystem trees.

* (Optional) Apply a patch to mark unused interface deprecated in
  percpu tree, so that new usages in linux-next can be detected.

* Towards the end of the next merge window, merge a patch to actually
  kill the old interface.

Thanks.

-- 
tejun
