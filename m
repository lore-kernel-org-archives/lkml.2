Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2ITPfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:35:03 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49353 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2ITPfB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 20 Sep 2012 11:35:01 -0400
Message-Id: <505B53D7020000780009CBB5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 20 Sep 2012 16:35:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Oliver Chick" <oliver.chick@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk
 drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
 <20120920134951.GC1998@localhost.localdomain>
In-Reply-To: <20120920134951.GC1998@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.09.12 at 15:49, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Thu, Sep 20, 2012 at 12:48:41PM +0100, Jan Beulich wrote:
>> >>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
>> > The memory overhead, and fallback mode points are related:
>> > -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
>> > per device. I made a mistake (pointed out by Jan) as the maximum number
>> > of requests that can fit into a single-page ring is 64, not 256.
>> > -Clearly, this still scales linearly. So the problem of memory footprint
>> > will occur with more VMs, or block devices.
>> > -Whilst 2.75MB per device is probably acceptable (?), if we start using
>> > multipage rings, then we might not want to have
>> > BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
>> > memory overhead to increase. This is why I have implemented the
>> > 'fallback' mode. With a multipage ring, it seems reasonable to want the
>> > first $x$ grefs seen by blkback to be treated as persistent, and any
>> > later ones to be non-persistent. Does that seem sensible?
>> 
>> From a resource usage pov, perhaps. But this will get the guest
>> entirely unpredictable performance. Plus I don't think 11Mb of
> 
> Wouldn't it fall back to the older performance?

Right, but the guest can't really predict this. That may have
significant impact if the performance difference is big enough.

Jan

