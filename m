Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1HJIGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:06:16 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:59991 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1HJIGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:06:06 -0400
X-IronPort-AV: E=Sophos;i="4.67,349,1309737600"; 
   d="scan'208";a="7202865"
Subject: Re: [PATCH] xen: modify kernel mappings corresponding to granted
 pages
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110809155014.GA4237@dumpdata.com>
References: <1311699345-32579-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20110809023407.GA13905@dumpdata.com>
	 <1312893028.26263.129.camel@zakaz.uk.xensource.com>
	 <20110809155014.GA4237@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Aug 2011 09:06:04 +0100
Message-ID: <1312963564.26263.154.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 16:50 +0100, Konrad Rzeszutek Wilk wrote:
> > > So I hadn't looked at this in detail, but I wonder if we can use the
> > > MULTIcall for this? It looks like we need to do two hypercalls so why
> > > not batch it?
> > 
> > That was going to be my next question. We should definitely batch these
> > if possible.
> > 
> > > And while we are it - we could change the MMU ops to only do this on
> > > initial domain and for the domU case do the old mechanism?
> > 
> > We need this in domU for driver domains and the like, don't we?
> 
> Sure, but I believe the majority of domU domains would not require this.

The overhead of this stuff is low if not used, isn't it? Compared with
the complexity of having domains know if they might be used as a driver
domain or not that seems like the tradeoff to be aiming for.

> I was thinking that when we start playing with the device/driver domains
> we would want to escalate the privilige level (or perhaps not)?

We don't want any escalation of privilege over and above what is
necessary to be a driver domain, which is generally none.

>  Or
> perhaps introcuce a new type - "if (xen_driver_domain())" to recognize
> that we are special ?

Where does the information to set xen_driver_domain == TRUE come from?

Ian.

