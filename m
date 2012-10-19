Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422647Ab2JSPS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:18:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796Ab2JSPSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:18:25 -0400
Date: Fri, 19 Oct 2012 11:17:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20121019151753.GF27052@redhat.com>
References: <20121017141234.GD31663@redhat.com>
 <20121018.120805.464238435.d.hatayama@jp.fujitsu.com>
 <20121018141449.GB18147@redhat.com>
 <20121019.122054.476812873.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019.122054.476812873.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 12:20:54PM +0900, HATAYAMA Daisuke wrote:

[..]
> > Instead of capturing the dump of whole memory, isn't it more efficient
> > to capture the crash dump of VM in question and then if need be just
> > take filtered crash dump of host kernel. 
> > 
> > I think that trying to take unfiltered crash dumps of tera bytes of memory
> > is not practical or woth it for most of the use cases.
> > 
> 
> If there's a lag between VM dump and host dump, situation on the host
> can change, and VM dump itself changes the situation. Then, we cannot
> know what kind of bug resides in now, so we want to do as few things
> as possible between detecting the bug reproduced and taking host
> dump. So I expressed ``capturing the situation''.

I would rather first detect the problem on guest and figure out what's
happening. Once it has been determined that something is wrong from
host side then debug what's wrong with host by using regular kernel
debugging techiniques. 

Even if you are interested in capturing crash dump, after you have
decided that it is a host problem, then you can write some scripts which
trigger host crash dump when relevant event happens.

Seriously, this argument could be extended to regular processes also.
Something is wrong with my application, so lets dump the whole system,
provide a facility to extract each process's code dump from that huge
dump and then examine if it was an application issue or kernel issue.

I am skeptical that this approach is going to fly in practice. Dumping
huge images, processing and transferring these is not very practical.
So I would rather narrow down the problem on a running system and take
filtered dump of appropriate component where I suspect the problem is.

[..]
> > capability was the primary reason that s390 also wants to support
> > kdump otherwise there firmware dumping mechanism was working just
> > fine.
> > 
> 
> I don't know s390 firmware dumping mechanism at all, but is it possble
> for s390 to filter crash dump even on firmware dumping mechanism?

AFAIK, s390 dump mechanism could not filter dump and tha's the reason
they wanted to support kdump and /proc/vmcore so that makedumpfile 
could filter it. I am CCing Michael Holzheu, who did the s390 kdump work.
He can tell it better.

Thanks
Vivek
