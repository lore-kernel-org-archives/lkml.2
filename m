Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2ITLsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:48:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41670 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2ITLsW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 20 Sep 2012 07:48:22 -0400
Message-Id: <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 20 Sep 2012 12:48:41 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Oliver Chick" <oliver.chick@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk
 drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
In-Reply-To: <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
> The memory overhead, and fallback mode points are related:
> -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
> per device. I made a mistake (pointed out by Jan) as the maximum number
> of requests that can fit into a single-page ring is 64, not 256.
> -Clearly, this still scales linearly. So the problem of memory footprint
> will occur with more VMs, or block devices.
> -Whilst 2.75MB per device is probably acceptable (?), if we start using
> multipage rings, then we might not want to have
> BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
> memory overhead to increase. This is why I have implemented the
> 'fallback' mode. With a multipage ring, it seems reasonable to want the
> first $x$ grefs seen by blkback to be treated as persistent, and any
> later ones to be non-persistent. Does that seem sensible?

>From a resource usage pov, perhaps. But this will get the guest
entirely unpredictable performance. Plus I don't think 11Mb of
_virtual_ space is unacceptable overhead in a 64-bit kernel. If
you really want/need this in a 32-bit one, then perhaps some
other alternatives would be needed (and persistent grants may
not be the right approach there in the first place).

Jan

