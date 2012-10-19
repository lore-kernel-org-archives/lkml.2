Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab2JSB4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:56:55 -0400
Received: from mail.bendigoit.com.au ([203.16.207.99]:52908 "EHLO
	smtp2.bendigoit.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2JSB4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:56:54 -0400
X-Greylist: delayed 1312 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2012 21:56:53 EDT
From: James Harper <james.harper@bendigoit.com.au>
To: Roger Pau Monne <roger.pau@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
CC: Oliver Chick <oliver.chick@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH RFC] Persistent grant maps for xen blk
 drivers
Thread-Topic: [Xen-devel] [PATCH RFC] Persistent grant maps for xen blk
 drivers
Thread-Index: AQHNrSPHQ3cOVHsv2Ui1q3f+GnpWRpe+90Qg
Date: Fri, 19 Oct 2012 01:34:40 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B32C1043A@BITCOM1.int.sbss.com.au>
References: <1350559321-19066-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1350559321-19066-1-git-send-email-roger.pau@citrix.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.222.114]
x-tm-as-product-ver: SMEX-10.2.0.2087-7.000.1014-19286.001
x-tm-as-result: No--39.354100-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Really-From-Bendigo-IT: magichashvalue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This patch implements persistent grants for the xen-blk{front,back}
> mechanism. The effect of this change is to reduce the number of unmap
> operations performed, since they cause a (costly) TLB shootdown. This allows
> the I/O performance to scale better when a large number of VMs are
> performing I/O.
> 
> Previously, the blkfront driver was supplied a bvec[] from the request
> queue. This was granted to dom0; dom0 performed the I/O and wrote
> directly into the grant-mapped memory and unmapped it; blkfront then
> removed foreign access for that grant. The cost of unmapping scales badly
> with the number of CPUs in Dom0. An experiment showed that when
> Dom0 has 24 VCPUs, and guests are performing parallel I/O to a ramdisk, the
> IPIs from performing unmap's is a bottleneck at 5 guests (at which point
> 650,000 IOPS are being performed in total). If more than 5 guests are used,
> the performance declines. By 10 guests, only
> 400,000 IOPS are being performed.
> 
> This patch improves performance by only unmapping when the connection
> between blkfront and back is broken.

I assume network drivers would suffer from the same affliction... Would a more general persistent map solution be worth considering (or be possible)? So a common interface to this persistent mapping allowing the persistent pool to be shared between all drivers in the DomU?

James

