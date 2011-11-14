Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1KNOiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:38:54 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25882 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1KNOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:38:53 -0500
Date: Mon, 14 Nov 2011 09:37:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: len.brown@intel.com, jeremy@goop.org, xen-devel@lists.xensource.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tj@kernel.org,
        tglx@linutronix.de, trenn@suse.de
Subject: Re: [Xen-devel] [PATCH 1/3] cpuidle: If disable_cpuidle() is called,
 set pm_idle to default_idle.
Message-ID: <20111114143716.GB8317@phenom.dumpdata.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
 <1320786914-10541-2-git-send-email-konrad.wilk@oracle.com>
 <20111110040644.GA5434@phenom.dumpdata.com>
 <CAJvTdKnSLD8q3QqcFVY7u-eyhTnN=2rQ3rTmd1qeJ7nGz4y5Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJvTdKnSLD8q3QqcFVY7u-eyhTnN=2rQ3rTmd1qeJ7nGz4y5Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4EC127AA.008E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 01:00:15AM -0500, Len Brown wrote:
> > And just found that there is a BZ for this as well:
> > https://bugzilla.redhat.com/show_bug.cgi?id=739499
> >
> > And this patch fixes the Linux kernel to boot under Amazon EC2.
> 
> doesn't matter.
> 
> Working around an Amazon EC2 bug in a newly compiled upstream kernel
> isn't going to help with any of the kernels that don't include that workaround.

Prior to 3.1 we did have a solution for this - we would use the default_idle
and not pick and/choose one based on the CPUID flags.

It was not really a choice made by "hypervisor wrongly advertises the
MWAIT flag", but rather that we want to use the safe_halt, which ends up
calling the yield hypercall.

That is the optimal solution irregardless of what version of hypervisor
is being used.

> 
> Amazon EC2 should not advertise MWAIT support that it does not have,
> and all kernels should run on it w/o any workaround.
> 
> Len Brown, Intel Open Source Technology Center
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
