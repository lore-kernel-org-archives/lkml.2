Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab2EKTht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:37:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31536 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab2EKThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:37:48 -0400
Date: Fri, 11 May 2012 15:31:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Xen physical cpus interface (V2)
Message-ID: <20120511193137.GE3785@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351B58A3@SHSMSX101.ccr.corp.intel.com>
 <20120511140454.GA13735@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351BA0B2@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351BA0B2@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +struct pcpu {
> >> +	struct list_head list;
> >> +	struct device dev;
> >> +	uint32_t cpu_id;
> >> +	uint32_t flags;
> >> +};
> >> +
> >> +static struct bus_type xen_pcpu_subsys = {
> >> +	.name = "xen_cpu",
> >> +	.dev_name = "xen_cpu",
> >> +};
> >> +
> >> +static DEFINE_MUTEX(xen_pcpu_lock);
> >> +
> >> +static LIST_HEAD(xen_pcpus);
> > 
> > So what about the recommendation to get rid of that and
> > instead do
> > 
> > struct pcpu *xen_cpu;
> 
> I'm not quite clear your meaning here, do you mean 'LIST_HEAD(xen_pcpus)' instead of 'struct pcpu *xen_cpu'?

No. Just use the embedded 'struct list_head' inside of 'struct pcpu'
as your iterator.

And your first 'struct pcpu' won't ever be deleted (as it is for
CPU0), so you can iterate from that.
