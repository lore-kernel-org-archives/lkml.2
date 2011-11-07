Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092Ab1KGVNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:13:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1KGVNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:13:05 -0500
Date: Mon, 7 Nov 2011 23:14:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: virtio-pci new configuration proposal
Message-ID: <20111107211413.GA11577@redhat.com>
References: <20111104114033.GA21308@redhat.com>
 <1320409939.3334.6.camel@lappy>
 <20111104135113.GA24452@redhat.com>
 <1320414804.3334.13.camel@lappy>
 <20111104142338.GB24452@redhat.com>
 <1320418385.3334.25.camel@lappy>
 <20111106073007.GA7146@redhat.com>
 <1320611097.3299.10.camel@lappy>
 <20111106213849.GA14292@redhat.com>
 <871utktsuw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871utktsuw.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:46:23PM +1030, Rusty Russell wrote:
> On Sun, 6 Nov 2011 23:38:49 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Sun, Nov 06, 2011 at 10:24:57PM +0200, Sasha Levin wrote:
> > > On Sun, 2011-11-06 at 09:30 +0200, Michael S. Tsirkin wrote:
> > > > On Fri, Nov 04, 2011 at 04:53:05PM +0200, Sasha Levin wrote:
> > > > > > I guess my assumption is that most options will be in use,
> > > > > > not discarded dead-ends.
> > > > > 
> > > > > I don't know about that. 64 bit features would be pretty rare for now -
> > > > > and I don't think that setting the alignment will be also enabled by
> > > > > default.
> 
> The truth is somewhere between.  New features tend to be used, and
> importantly, they have to be offered.
> 
> Anyway, the *per-device* config part will be contiguous.  So we're
> talking about pci-specific features.
> 
> So far, the only three things make sense to have in a capability list:
> MSI-X, the upper 32 feature bits, and the per-device config.
> 
> Thanks,
> Rusty.

You mean the queue # to MSI-X vector mapping?
One thing to remember is that it must be in the same type of BAR as
the queue selection, since by PCI rules MMIO writes aren't I think
ordered with PIO writes (it doesn't matter with KVM but might
with another hypervisor).

-- 
MST
