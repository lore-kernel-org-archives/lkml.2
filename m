Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0JUCiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:38:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab0JUCiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:38:06 -0400
Date: Wed, 20 Oct 2010 22:37:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
Message-ID: <20101021023752.GB12086@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
 <20101019150701.GR5969@erda.amd.com>
 <20101019162507.GU5969@erda.amd.com>
 <20101019183720.GN4140@redhat.com>
 <1287534192.3026.9.camel@yhuang-dev>
 <20101020142734.GD19090@redhat.com>
 <1287621607.19320.7.camel@yhuang-dev>
 <20101021011813.GH19090@redhat.com>
 <1287624309.19320.52.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287624309.19320.52.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 09:25:09AM +0800, Huang Ying wrote:
> On Thu, 2010-10-21 at 09:18 +0800, Don Zickus wrote:
> > On Thu, Oct 21, 2010 at 08:40:07AM +0800, Huang Ying wrote:
> > > On Wed, 2010-10-20 at 22:27 +0800, Don Zickus wrote:
> > > > I thought the point of this patch was to remove that restriction in the
> > > > nmi handler, which would allow future patches to re-route these NMIs to
> > > > another cpu, thus finally allowing people to hot-remove the bsp cpu, no?
> > > 
> > > Yes. We just want to make it possible to hot-remove the bsp cpu. Because
> > > IOAPIC is configurable, I think it is possible to configure IOAPIC to
> > > send PCI SERR NMI to one CPU while IOCK NMI to another CPU. Why not
> > > support this situation too? It does not harm anything but performance to
> > 
> > Why would we want to?  It seems simpler to have one cpu dedicated to
> > handling the external NMIs.
> 
> If we can guarantee that these NMIs will be only sent to one CPU, I am
> fine with trylock.

I guess I assumed the BIOS would only use the bsp CPU for the NMI, which
would be passed on to the kernel.  Otherwise what happens if an NMI
happens while the kernel is still bringing up the first cpu and it is
routed to another CPU or if we boot with MAX_CPUS=1?

Then again people keep saying BIOS writers are crazy, so my assumption
could be completely wrong. ;-p

Cheers,
Don
