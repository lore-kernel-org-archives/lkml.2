Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab2EIPeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:34:13 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:12008 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab2EIPeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:34:11 -0400
Message-ID: <1336577648.2498.9.camel@lorien2>
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Igor Mammedov <imammedo@redhat.com>
Cc: shuahkhan@gmail.com, linux-kernel@vger.kernel.org, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@mit.edu, suresh.b.siddha@intel.com, avi@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, arjan@linux.intel.com,
        linux-doc@vger.kernel.org
Date: Wed, 09 May 2012 09:34:08 -0600
In-Reply-To: <4FAA8BCC.5000704@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
	 <1336559102-28103-2-git-send-email-imammedo@redhat.com>
	 <1336575858.2498.7.camel@lorien2> <4FAA8BCC.5000704@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 17:22 +0200, Igor Mammedov wrote:
> On 05/09/2012 05:04 PM, Shuah Khan wrote:
> > On Wed, 2012-05-09 at 12:24 +0200, Igor Mammedov wrote:
> >> When bringing up cpuX1, it could stall in start_secondary
> >> before setting cpu_callin_mask for more than 5 sec. That forces
> >> do_boot_cpu() to give up on waiting and go to error return path
> >> printing messages:
> >>    pr_err("CPU%d: Stuck ??\n", cpuX1);
> >
> > I am seeing this with the linux-next May 7th build on my laptop HP
> > EliteBook 8440p during boot. Could this problem be not specific to virt
> > envs.? Anybody else seeing it?
> 
> I could only guess that on bare metal SMI or other firmware issue may interfere with AP boot.
> Could you test if this patch-set fixes issue for you?
> And do you see the same problem during suspend/resume (assuming that it's booted without problem)?
> 

I had to abandon the boot and go back to distro installed kernel - yes I
will test with your patch set and see if the problem goes away. Might
not happen until close to end of day today, but will report back.

-- Shuah


