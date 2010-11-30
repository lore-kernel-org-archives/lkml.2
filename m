Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0K3SPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:15:36 -0500
Received: from sous-sol.org ([216.99.217.87]:55632 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755592Ab0K3SPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:15:35 -0500
Date: Tue, 30 Nov 2010 10:13:14 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] Fix dmar fault interrupt problems
Message-ID: <20101130181314.GH10050@sequoia.sous-sol.org>
References: <4CF4B597.4030708@jp.fujitsu.com>
 <1291140553.2623.10.camel@sbsiddha-MOBL3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291140553.2623.10.camel@sbsiddha-MOBL3>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha (suresh.b.siddha@intel.com) wrote:
> On Tue, 2010-11-30 at 00:28 -0800, Kenji Kaneshige wrote:
> > Hi,
> > 
> > Here are patches to fix the following problems regarding dmar fault interrupt.
> > 
> > - No dmar fault event is notified in x2apic cluster mode
> > - Changing IRQ affinity of dmar fault interrupt causes "No irq handler
> >   for vector (irq XX)" message and dmar fault interrupts are never
> >   notified after that.
> 
> Kenji, In addition to these two, there are couple of more patches that
> are needed to fix the kexec/kdump issue that we are debugging on RH
> bugzilla.
> 
> I will post all these 4 patches shortly. I already noticed and queued
> the second patch (dmar irq migration)  you mentioned.

And one of them (the additional call to flushing existing dmar faults)
is not needed.  So the quirk plus ensuring ir faults show up as msi
interrupts should be sufficient.

thanks,
-chris
