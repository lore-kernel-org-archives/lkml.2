Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab2HNKKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:10:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab2HNKKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:10:19 -0400
Date: Tue, 14 Aug 2012 13:10:15 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120814101014.GF11194@redhat.com>
References: <1343848002.6698.38.camel@bling.home>
 <20120812074936.GA1421@redhat.com>
 <1344876495.4683.47.camel@ul30vt.home>
 <20120813165938.GA19139@redhat.com>
 <1344881845.4683.95.camel@ul30vt.home>
 <20120813194938.GB19139@redhat.com>
 <1344890905.4683.120.camel@ul30vt.home>
 <20120813215043.GA15639@redhat.com>
 <1344896532.4683.170.camel@ul30vt.home>
 <20120813225213.GB1931@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813225213.GB1931@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:52:13AM +0300, Michael S. Tsirkin wrote:
> > Using the EOI as a trigger to de-assert and potentially re-assert may be
> > a hack, but it's about as close as we can come to following the behavior
> > of hardware.
> > It's actually quite similar to an apic re-sampling inputs
> > except we don't have a physical line to read and see that it's still
> > asserted.  We emulate this by de-asserting it and letting it re-assert
> > if necessary.  The emulation to the guest isn't perfect, but it's a lot
> > closer than immediately de-asserting the pin.
> > I think the discussion
> > below describes why I do this versus something that might be even closer
> > to actual hardware.
> 
> Sorry I don't understand what "quite similar" means.  If deassert on ack
> is "closer" somehow show me some software that needs it.
> 
This is incorrect question to ask. The correct one is "is there guest
visible effect" and the answer is yes. If guest reads ioapic irr before
eoi it will incorrectly read zero. Now when we know what is guest visible
effect we can think about whether we can live with it. But it looks like
we can't since this have more serious implications. If interrupt is masked
in ioapic during irq delivery interrupt will be never delivered after unmask.

--
			Gleb.
