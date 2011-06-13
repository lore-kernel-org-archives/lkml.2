Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab1FMULC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:11:02 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:47661 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1FMULB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:11:01 -0400
Date: Mon, 13 Jun 2011 22:10:58 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: QEMU Kernel panic - not syncing: IO-APIC +
 timer doesn't work!
Message-ID: <20110613201058.GB20616@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613173532.GG3502@yumi.tdiedrich.de>
 <20110613183825.GA31895@dumpdata.com>
 <20110613191406.GA20616@yumi.tdiedrich.de>
 <20110613194547.GA4715@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613194547.GA4715@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 13, 2011 at 09:14:07PM +0200, Tobias Diedrich wrote:
> > Konrad Rzeszutek Wilk wrote:
> > > On Mon, Jun 13, 2011 at 07:35:32PM +0200, Tobias Diedrich wrote:
> > > > Hi,
> > > > 
> > > > I ran into this problem when trying to set up Xen on a root server
> > > > with a pre-Orleans Athlon64 (no svm, so no kvm):
> > > 
> > > Uhh, your output says otherwise. What is the serial output your
> > > box produced?
> > 
> > Well, the output was from the kvm where I tried to boot xen with the
> > same config as on my rootserver, where I don't have access to the
> > console output to see why it doesn't boot. :)
> 
> I've traced it down to the fact that you disable SMP on your x86_64 build.
> 
> CONFIG_BROKEN_ON_SMP=y
> # CONFIG_SMP is not set
> 
> Is there a particular reason for doing that? Can you try your build
> with CONFIG_SMP=y set? Also, don't set CONFIG_MAXSMP (as that one is
> right now broken).

Cool.  I disabled it because its a single-core system. :)
With CONFIG_SMP=y it works for me in kvm, and just confirmed it also
works on my server now.

Thanks,

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
