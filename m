Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab1ESSlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:41:21 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:40333 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933792Ab1ESSlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:41:19 -0400
Date: Thu, 19 May 2011 12:41:13 -0600
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
Message-ID: <20110519184113.GE12525@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
 <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTikOCeNcDvoCM=BOSxQaSECFhJ05Gg@mail.gmail.com>
 <20110519174420.GD12525@obsidianresearch.com>
 <BANLkTikOsqazAE-mHFrM+=4GTs+249Ae5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikOsqazAE-mHFrM+=4GTs+249Ae5Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:34:08PM +0200, Bart Van Assche wrote:
> My reply applies to your original statement where you were referring
> to APM with different destination ports. What you write above is about
> APM with identical destination ports and hence does not apply to my
> reply.

The subnet manager can give an APM result that will switch between
ports on the same node, APM handles both switching to a different path
with the same end ports, and also switching to a new path using the
same end ports. An implementation supporting APM must be ready for
both situations - realistically no additional app code is required to
support the multiport case since it falls out for free. You'd actually
have to actively work to prevent it...

This is why in the IB verbs architecture nearly everything is tied to
a *device*, not a port.

Jason
