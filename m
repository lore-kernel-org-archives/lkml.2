Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0JUBZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:25:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:57261 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0JUBZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:25:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,214,1286175600"; 
   d="scan'208";a="565979803"
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
In-Reply-To: <20101021011813.GH19090@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
	 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
	 <20101019150701.GR5969@erda.amd.com> <20101019162507.GU5969@erda.amd.com>
	 <20101019183720.GN4140@redhat.com> <1287534192.3026.9.camel@yhuang-dev>
	 <20101020142734.GD19090@redhat.com> <1287621607.19320.7.camel@yhuang-dev>
	 <20101021011813.GH19090@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 09:25:09 +0800
Message-ID: <1287624309.19320.52.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 09:18 +0800, Don Zickus wrote:
> On Thu, Oct 21, 2010 at 08:40:07AM +0800, Huang Ying wrote:
> > On Wed, 2010-10-20 at 22:27 +0800, Don Zickus wrote:
> > > I thought the point of this patch was to remove that restriction in the
> > > nmi handler, which would allow future patches to re-route these NMIs to
> > > another cpu, thus finally allowing people to hot-remove the bsp cpu, no?
> > 
> > Yes. We just want to make it possible to hot-remove the bsp cpu. Because
> > IOAPIC is configurable, I think it is possible to configure IOAPIC to
> > send PCI SERR NMI to one CPU while IOCK NMI to another CPU. Why not
> > support this situation too? It does not harm anything but performance to
> 
> Why would we want to?  It seems simpler to have one cpu dedicated to
> handling the external NMIs.

If we can guarantee that these NMIs will be only sent to one CPU, I am
fine with trylock.

> > use raw_spin_lock() instead of raw_spin_trylock() here. And for hardware
> > error processing, performance is not so important in fact.
> 
> I don't know.  I was always a little uncomfortable with a spin_lock there,
> so I am more supportive of a trylock.

Best Regards,
Huang Ying

