Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab2ESKrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:47:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42545 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692Ab2ESKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:47:30 -0400
Date: Sat, 19 May 2012 14:47:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120519104725.GA18768@moon>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120518144153.GD8455@moon>
 <20120518154236.GA23406@dhcp-26-207.brq.redhat.com>
 <20120518155119.GG8455@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518155119.GG8455@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 07:51:19PM +0400, Cyrill Gorcunov wrote:
> On Fri, May 18, 2012 at 05:42:37PM +0200, Alexander Gordeev wrote:
> > > Hi Alexander,
> > > 
> > > I'm a bit confused, we do compose destination id from target cpumask
> > > and send one ipi per _cluster_ with all cpus belonging to this cluster
> > > OR'ed. So if my memory doesn't betray me all specified cpus in cluster
> > > should obtain this message. Thus I'm wondering where do you find that
> > > only one apic obtains ipi? (note i don't have the real physical
> > > machine with x2apic enabled handy to test, so please share
> > > the experience).
> > 
> > This patchset is not about IPIs at all. It is about interrupts coming from
> > IO-APICs.
> 
> Ah, you mean io-apic here. I'll try to find some time tonight/tomorrow-morning
> for review. Thanks!

Sorry for delay, Alexander. I can only review the code (I've no x2apic
testing machine at the moment) and it looks good for me.

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

p.s. Hope Suresh and Yinghai will take a look too. The thing which bothers
me is that we use LowPrio delivery mode, while there is no lowprio in
x2apic ipi messages and I assume the same should apply to ioapic generated
messages.

	Cyrill
