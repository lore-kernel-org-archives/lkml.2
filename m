Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1JSOGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:06:44 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29430 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab1JSOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:06:43 -0400
Date: Wed, 19 Oct 2011 10:05:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH] XEN_DOMAIN_MEMORY options.
Message-ID: <20111019140525.GC7313@phenom.dumpdata.com>
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
 <4E98BEF5.10801@goop.org>
 <4E98C6CE.4020508@oracle.com>
 <4E98C8B1.20304@goop.org>
 <4E98D739.4000705@oracle.com>
 <20111015130552.GC18864@andromeda.dapyr.net>
 <1318696968.11016.47.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318696968.11016.47.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E9ED934.00C1:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 05:42:48PM +0100, Ian Campbell wrote:
> On Sat, 2011-10-15 at 09:05 -0400, Konrad Rzeszutek Wilk wrote:
> > > On 10/14/2011 04:41 PM, Jeremy Fitzhardinge wrote:
> 
> > > >While it would be very silly to put 128GB of actual RAM on a 32-bit
> > > >machine, systems can have non-contiguous RAM placed at high addresses,
> > > >which would no longer be accessible.
> > 
> > Do you have some ideas of which machines that might be?
> 
> Even if you were on such a machine, the discontiguity
> (discontiguousness?) wouldn't ever be reflected in the pseudo-physical
> memory map, would it? So since this variable controls the maximum size
> of the p2m (rather than the m2p) it doesn't need to be larger than the
> maximum sane 32 bit guest size (<64G).

I think it is the other way around. The M2P would not be affected but
the P2M might? The "discontinuity" is in the E820 right? (so mega big
holes in it).
