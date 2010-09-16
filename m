Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0IPJZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab0IPJZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:25:55 -0400
Date: Thu, 16 Sep 2010 11:25:53 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916092553.GV3008@redhat.com>
References: <20100915185417.GA3924@redhat.com>
 <20100916090256.GU3008@redhat.com>
 <20100916091054.GA20864@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916091054.GA20864@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 11:10:55AM +0200, Michael S. Tsirkin wrote:
> On Thu, Sep 16, 2010 at 11:02:56AM +0200, Gleb Natapov wrote:
> > On Wed, Sep 15, 2010 at 08:54:17PM +0200, Michael S. Tsirkin wrote:
> > > To avoid bouncing irqfd injection out to workqueue context,
> > > we must support injecting irqs from local interrupt
> > > context. Doing this seems to only require disabling
> > > irqs locally.
> > > 
> > > RFC, completely untested, x86 only.
> > > 
> > > Thoughts?
> > > 
> > We do not want to disable irqs for a long time and some of code paths
> > under lock involve looping over all cpus. For MSI injection path is
> > lockless and this is the only case that matters,
> 
> MSI only appeared in rhel6, older guests still use level interrupts.
So they are already slow for other reasons.

> Which paths require looping over all cpus? Do PCI interrupts
> need this?
> 
All interrupts need it. IOAPIC has a loop to find dst cpu for interrupt.
Pic has a loop to find cpu in virtual wire mode.

--
			Gleb.
