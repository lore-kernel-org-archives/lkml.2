Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2FGU4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:56:13 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:14435 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752946Ab2FGU4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:56:11 -0400
Message-ID: <1339102567.2770.25.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [V2 RFC net-next PATCH 2/2] virtio_net: export more statistics
 through ethtool
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rick Jones <rick.jones2@hp.com>
CC: David Miller <davem@davemloft.net>, <jasowang@redhat.com>,
        <netdev@vger.kernel.org>, <rusty@rustcorp.com.au>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <mst@redhat.com>
Date: Thu, 7 Jun 2012 21:56:07 +0100
In-Reply-To: <4FD11194.2040405@hp.com>
References: <20120606075208.29081.75284.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1339089306.2770.10.camel@bwh-desktop.uk.solarflarecom.com>
	 <20120607.130512.219951433412203999.davem@davemloft.net>
	 <1339100649.2770.20.camel@bwh-desktop.uk.solarflarecom.com>
	 <4FD11194.2040405@hp.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18952.004
X-TM-AS-Result: No--13.919600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 13:39 -0700, Rick Jones wrote:
> On 06/07/2012 01:24 PM, Ben Hutchings wrote:
> > On Thu, 2012-06-07 at 13:05 -0700, David Miller wrote:
> >> From: Ben Hutchings<bhutchings@solarflare.com>
> >> Date: Thu, 7 Jun 2012 18:15:06 +0100
> >>
> >>> I would really like to see some sort of convention for presenting
> >>> per-queue statistics through ethtool.  At the moment we have a complete
> >>> mess of different formats:
> >>
> >> Indeed.  Probably ${QUEUE_TYPE}-${INDEX}-${STATISTIC} is best.
> >> With an agreed upon list of queue types such as "rx", "tx", "rxtx"
> >> etc.
> >
> > I think we should leave the type names open-ended, as there are other
> > useful groupings like per-virtual-port.  In that case the separator
> > should be chosen to allow arbitrary type names without ambiguity.
> 
> So you mean like something along the lines of the presence of say '.' 
> indicating indent a level:
> 
> rx_bytes:  1234
>      myqueue1.rx_bytes: 234
>      myqueue2.rx_bytes: 345
>      ...

Most drivers seem to want this sort of ordering/grouping:

group0.foo
group0.bar
...
group1.foo
group1.bar
...

but if we have a standard way of indicating groups of statistics then
the user can choose whether they want to reorder by type name.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

