Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0FHQN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:13:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41717 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab0FHQN5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Jun 2010 12:13:57 -0400
Date: Tue, 8 Jun 2010 12:12:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@Oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 02/12] early PV on HVM
Message-ID: <20100608161233.GA4900@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com> <20100604202008.GB17645@phenom.dumpdata.com> <alpine.DEB.2.00.1006071518050.3401@kaball-desktop> <20100608134637.GA5998@phenom.dumpdata.com> <alpine.DEB.2.00.1006081643280.3401@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006081643280.3401@kaball-desktop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C0E6C32.0042:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 04:55:33PM +0100, Stefano Stabellini wrote:
> On Tue, 8 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > > > > +	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> > > > > +
> > > > > +	/* Don't do the full vcpu_info placement stuff until we have a
> > > > > +	   possible map and a non-dummy shared_info. */
> > > > 
> > > > Might want to mention where the full vpcu placement is done.
> > > 
> > > The comment is not accurate, we actually don't do any vcpu_info
> > > placement on hvm because it is not very useful there.
> > > Better just to remove the comment (I have done so in my tree).
> > > 
> > > > > +	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> > > > 
> > So.. what is the purpose of the per_cpu(xen_vcpu, 0) then?
> > 
> 
> the vcpu info placement memory area is stored in per_cpu(xen_vcpu_info, cpu);
> per_cpu(xen_vcpu, cpu) is just a pointer to that area if it is
> available, otherwise it points to the vcpu_info struct in the shared
> info page.

I was just wondering why are we doing this when you say:
" don't do any vcpu_info placement on hvm because it is not very useful there."

So if it is not useful, why do it?
