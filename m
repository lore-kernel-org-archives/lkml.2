Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2ITKJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:09:48 -0400
Received: from smtp.tele.fi ([192.89.123.25]:62275 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab2ITKJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:09:47 -0400
X-Originating-Ip: [194.89.68.22]
Date: Thu, 20 Sep 2012 13:09:43 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Oliver Chick <oliver.chick@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120920100943.GX8912@reaktio.net>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <20120919131632.GS8912@reaktio.net>
 <1348133733.24539.8.camel@oliverchick-Precision-WorkStation-T3400>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348133733.24539.8.camel@oliverchick-Precision-WorkStation-T3400>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:35:33AM +0100, Oliver Chick wrote:
> I have attached a graph that shows the results of my benchmarking.
> 
> The setup is:
> -Xeon X5650
> -32GB of Ram
> -Xen 4.2
> -Linux 3.5.0 for dom0 and domus
> -Dom0 has 24 CPUs.
> -Each guest has a (separate) xvdb backed by a 1GB ramdisk (/dev/ramX) in
> dom0. No LVM on these.
> -The setup is that initially 1 guest does an fio sequential read of the
> ramdisk, then 2, then 3 etc.
> -The y axis is the sum of the iops, as reported by the guests' fio
> output.
> 

Thanks! The graph looks pretty nice :)

-- Pasi

> On Wed, 2012-09-19 at 14:16 +0100, X5650Pasi Kärkkäinen wrote:
> > On Wed, Sep 19, 2012 at 11:51:27AM +0100, Oliver Chick wrote:
> > > This patch implements persistent grants for the xen-blk{front,back}
> > > mechanism. The effect of this change is to reduce the number of unmap
> > > operations performed, since they cause a (costly) TLB shootdown. This
> > > allows the I/O performance to scale better when a large number of VMs
> > > are performing I/O.
> > > 
> > > Previously, the blkfront driver was supplied a bvec[] from the request
> > > queue. This was granted to dom0; dom0 performed the I/O and wrote
> > > directly into the grant-mapped memory and unmapped it; blkfront then
> > > removed foreign access for that grant. The cost of unmapping scales
> > > badly with the number of CPUs in Dom0. An experiment showed that when
> > > Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
> > > ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
> > > (at which point 650,000 IOPS are being performed in total). If more
> > > than 5 guests are used, the performance declines. By 10 guests, only
> > > 400,000 IOPS are being performed.
> > > 
> > > This patch improves performance by only unmapping when the connection
> > > between blkfront and back is broken.
> > >
> > 
> > So how many IOPS can you get with this patch / persistent grants ? 
> > 
> > -- Pasi
> > 
> 


