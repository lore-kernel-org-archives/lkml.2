Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1FMS4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:56:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63186 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1FMS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:56:40 -0400
Date: Mon, 13 Jun 2011 14:56:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tobias Diedrich <ranma+xen@tdiedrich.de>, xen-users@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: QEMU Kernel panic - not syncing: IO-APIC + timer
 doesn't work!
Message-ID: <20110613185602.GB31895@dumpdata.com>
References: <20110613173532.GG3502@yumi.tdiedrich.de>
 <20110613183825.GA31895@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613183825.GA31895@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DF65D61.00AB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 02:38:25PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 13, 2011 at 07:35:32PM +0200, Tobias Diedrich wrote:
> > Hi,
> > 
> > I ran into this problem when trying to set up Xen on a root server
> > with a pre-Orleans Athlon64 (no svm, so no kvm):
> 
> Uhh, your output says otherwise. What is the serial output your
> box produced?
> > 
> > Since 3.0-rc is supposed to have Xen DOM0 support I of course want
> > to use this rather than some old xenified kernel version. :)
> > 
> 
> Ok.
> > I later got it to boot using "noapic apci=off" (just noapic wasn't
> > sufficient, I had to add acpi=off because it had interrupt routing
> > problems with just noapic), and I can see that the APIC handlers in
> > arch/x86/xen/enlighten.c are just stubs so far.
> 
> Right.
> > 
> > So is this supposed to work with APICs?
> 
> Yes. Well, it actually should just bypass/ignore the APIC calls and
> the warnings are suppose to be benign.
> 
> But somehow your environment triggered a weird state. I've to admint
> I hadn't tried to boot Xen + paravirt Linux under QEMU for some time.

Just tried (but didn't do it with KVM, just normal QEMU without KVM or Xen)
and I was able to reproduce the issue you saw. Thought it looks like as if
my default .config does not cause this issue.
