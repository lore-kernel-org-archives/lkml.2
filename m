Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0HPOC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:02:27 -0400
Received: from mxout1.idt.com ([157.165.5.25]:46325 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab0HPOC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:02:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/9] RapidIO: Add relation links between RIO device structures
Date: Mon, 16 Aug 2010 07:00:37 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F1F@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C692C9D.6040100@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 4/9] RapidIO: Add relation links between RIO device structures
thread-index: Acs9PMnJNuqkcBn9TVSSsYc2ykoXwQADA6GQ
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-5-git-send-email-alexandre.bounine@idt.com> <4C692C9D.6040100@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> > Create back and forward links between RIO devices. These links are
intended for
> > use by error management and hot-plug extensions.
> 
> As RapidIO is a switched network, the concept of 'previous' and 'next'
> devices is invalid. Perhaps it's just the way they were
> discovered/enumerated, but that does not matter any more at runtime.
Or
> at least, should not matter.
>

Yes, the "previous" and "next" have to be considered in context of
enumeration/discovery.
At runtime, it does not matter for data traffic, but is valuable
information for error recovery
And hot-swap. This provides snapshot of device connections. For example,
when servicing
error-stopped state of link between two switches you need to know
ingress port of far switch on
the link. It may be a problem to read it directly from the device.
Searching through the device list
becomes time consuming as a system size grows.      
 
> > @@ -237,6 +241,7 @@ struct rio_switch {
> >  	u16 hopcount;
> >  	u16 destid;
> >  	u8  inport;
> > +	u8  nports;
> >  	u8 *route_table;
> >  	u32 port_ok;
> 
> This can be extracted from the swpinfo field (which you removed in
> another patch)?
> 
Agreed in response for patch #3

