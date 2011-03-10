Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1CJFln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:41:43 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17858 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1CJFlm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 00:41:42 -0500
Date: Thu, 10 Mar 2011 00:40:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 13/14] xen: events: do not workaround
 too-small nr_irqs
Message-ID: <20110310054045.GF10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
 <1299692486-28634-13-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299692486-28634-13-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0204.4D78648F.00F2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:41:25PM +0000, Ian Campbell wrote:
> This workaround was somewhat useful prior to the introduction of the
> core irq allocator and 026c9d2d0d75 "xen: events: allocate GSIs and
> dynamic IRQs from separate IRQ ranges." but should be unnecessary now.

OK, so you tested this under QEMU with Xen + Dom0? A simple one CPU
config was what we had trouble with.
> 
> If nr_irqs turns out to be too small under Xen then we should increase
> nr_irqs rather than working around the core allocator in this way.
> 
> In my configuration NR_IRQS ends up being 2304 with nr_irq_gsi 272
> which is sufficient.
