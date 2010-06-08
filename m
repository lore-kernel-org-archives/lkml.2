Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0FHP4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:56:39 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:11228 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0FHP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:56:37 -0400
X-IronPort-AV: E=Sophos;i="4.53,385,1272844800"; 
   d="scan'208";a="302083"
Date: Tue, 8 Jun 2010 16:55:33 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 02/12] early PV on HVM
In-Reply-To: <20100608134637.GA5998@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006081643280.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com> <20100604202008.GB17645@phenom.dumpdata.com> <alpine.DEB.2.00.1006071518050.3401@kaball-desktop>
 <20100608134637.GA5998@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > > > +	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> > > > +
> > > > +	/* Don't do the full vcpu_info placement stuff until we have a
> > > > +	   possible map and a non-dummy shared_info. */
> > > 
> > > Might want to mention where the full vpcu placement is done.
> > 
> > The comment is not accurate, we actually don't do any vcpu_info
> > placement on hvm because it is not very useful there.
> > Better just to remove the comment (I have done so in my tree).
> > 
> > > > +	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> > > 
> So.. what is the purpose of the per_cpu(xen_vcpu, 0) then?
> 

the vcpu info placement memory area is stored in per_cpu(xen_vcpu_info, cpu);
per_cpu(xen_vcpu, cpu) is just a pointer to that area if it is
available, otherwise it points to the vcpu_info struct in the shared
info page.

