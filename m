Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2ITNuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:50:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37096 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2ITNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:50:09 -0400
Date: Thu, 20 Sep 2012 09:49:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Oliver Chick <oliver.chick@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120920134951.GC1998@localhost.localdomain>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 12:48:41PM +0100, Jan Beulich wrote:
> >>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
> > The memory overhead, and fallback mode points are related:
> > -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
> > per device. I made a mistake (pointed out by Jan) as the maximum number
> > of requests that can fit into a single-page ring is 64, not 256.
> > -Clearly, this still scales linearly. So the problem of memory footprint
> > will occur with more VMs, or block devices.
> > -Whilst 2.75MB per device is probably acceptable (?), if we start using
> > multipage rings, then we might not want to have
> > BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
> > memory overhead to increase. This is why I have implemented the
> > 'fallback' mode. With a multipage ring, it seems reasonable to want the
> > first $x$ grefs seen by blkback to be treated as persistent, and any
> > later ones to be non-persistent. Does that seem sensible?
> 
> From a resource usage pov, perhaps. But this will get the guest
> entirely unpredictable performance. Plus I don't think 11Mb of

Wouldn't it fall back to the older performance?
> _virtual_ space is unacceptable overhead in a 64-bit kernel. If
> you really want/need this in a 32-bit one, then perhaps some
> other alternatives would be needed (and persistent grants may
> not be the right approach there in the first place).
> 
> Jan
> 
