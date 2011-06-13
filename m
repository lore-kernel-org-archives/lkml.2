Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1FMTqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:46:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22524 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1FMTqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:46:23 -0400
Date: Mon, 13 Jun 2011 15:45:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tobias Diedrich <ranma+kvm@tdiedrich.de>, xen-users@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: QEMU Kernel panic - not syncing: IO-APIC + timer
 doesn't work!
Message-ID: <20110613194547.GA4715@dumpdata.com>
References: <20110613173532.GG3502@yumi.tdiedrich.de>
 <20110613183825.GA31895@dumpdata.com>
 <20110613191406.GA20616@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613191406.GA20616@yumi.tdiedrich.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DF66908.0135:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 09:14:07PM +0200, Tobias Diedrich wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Mon, Jun 13, 2011 at 07:35:32PM +0200, Tobias Diedrich wrote:
> > > Hi,
> > > 
> > > I ran into this problem when trying to set up Xen on a root server
> > > with a pre-Orleans Athlon64 (no svm, so no kvm):
> > 
> > Uhh, your output says otherwise. What is the serial output your
> > box produced?
> 
> Well, the output was from the kvm where I tried to boot xen with the
> same config as on my rootserver, where I don't have access to the
> console output to see why it doesn't boot. :)

I've traced it down to the fact that you disable SMP on your x86_64 build.

CONFIG_BROKEN_ON_SMP=y
# CONFIG_SMP is not set

Is there a particular reason for doing that? Can you try your build
with CONFIG_SMP=y set? Also, don't set CONFIG_MAXSMP (as that one is
right now broken).

> 
> > > So is this supposed to work with APICs?
> > 
> > Yes. Well, it actually should just bypass/ignore the APIC calls and
> > the warnings are suppose to be benign.
> > 
> > But somehow your environment triggered a weird state. I've to admint
> > I hadn't tried to boot Xen + paravirt Linux under QEMU for some time.
> > 
> > Did you try this on real hardware?
> 
> Only on my rootserver.  Just tried it again just in case and it
> still doesn't boot if I remove the "noapic acpi=off" options.
> (And it seems to blow up before I get any output over netconsole)
> 
> I should try it on my notebook I guess, though that is a Core2 Intel
> with Vanderpool IIRC, so it may behave differently there.

That really should not be neccessary.
