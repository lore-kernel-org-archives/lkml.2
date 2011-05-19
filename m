Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab1ESRo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:44:26 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:43583 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab1ESRoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:44:25 -0400
Date: Thu, 19 May 2011 11:44:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rmda <linux-rdma@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Vu Pham <vu@mellanox.com>,
        David Dillow <dillowda@ornl.gov>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
 merge
Message-ID: <20110519174420.GD12525@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
 <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 07:29:21PM +0200, Bart Van Assche wrote:
> Regarding APM: the Linux kernel already has multipath support and
> duplicate functionality is in general not welcomed. So you will have
> to come up with a very good reason before APM support in ib_srp or
> ib_srpt would be considered for acceptance.

APM is a feature of IB's tranport layerthat provides disruption free
lossless failover to a backup network path completely transparently to
the application (eg SRP in this case).

This plays a similar role in the IB stack to the realtime spanning
tree protocol that ethernet uses, or the multipath IP routing that is
already in the net stack. I don't see it duplicating SCSI multipath at
all. On very large IB networks (eg > 1000 switches) the rate of link
failures is high enough that taking an application level recovery on
hundreds of nodes due to a link failure is troublesome.

If ib_srpt is implemented properly it may already support APM because
APM is supported by the IB CM that it relies on to setup connections,
and any SRP client could already request APM functionality during
connection setup.

Jason
