Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032366Ab2CSRyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:54:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46567 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032356Ab2CSRyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:54:10 -0400
Date: Mon, 19 Mar 2012 13:49:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Akshay Karle <akshay.a.karle@gmail.com>, avi@redhat.com
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 2/2] kvm: guest-side changes for tmem on KVM
Message-ID: <20120319174954.GD5063@phenom.dumpdata.com>
References: <1331226157.2585.33.camel@aks>
 <20120315170316.GM30250@phenom.dumpdata.com>
 <1331874035.2790.5.camel@aks>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331874035.2790.5.camel@aks>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F6772C0.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 10:30:35AM +0530, Akshay Karle wrote:
> >> +/* kvm tmem foundation ops/hypercalls */
> >> +
> >> +static inline int kvm_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
> >> +	u32 index, u32 tmem_offset, u32 pfn_offset, unsigned long pfn, u32 len, uint16_t cli_id)
> >
> > That is rather long list of arguments. Could you pass in a structure instead?
> >
> > Are you actually using all of the arguments in every call?
> 
> For different functions different parameters are used. If we want to reduce the number of arguments,
> the tmem_ops structure can be created in the functions calling kvm_tmem_op instead of creating it here
> and that can be passed, will make these changes in the next patch.
> 
> >> +{
> >> +	struct tmem_ops op;
> >> +	int rc = 0;
> >> +	op.cmd = tmem_cmd;
> >> +	op.pool_id = tmem_pool;
> >> +	op.u.gen.oid[0] = oid.oid[0];
> >> +	op.u.gen.oid[1] = oid.oid[1];
> >> +	op.u.gen.oid[2] = oid.oid[2];
> >> +	op.u.gen.index = index;
> >> +	op.u.gen.tmem_offset = tmem_offset;
> >> +	op.u.gen.pfn_offset = pfn_offset;
> >> +	op.u.gen.pfn = pfn;
> >> +	op.u.gen.len = len;
> >> +	op.u.gen.cli_id = cli_id;
> >> +	rc = kvm_hypercall1(KVM_HC_TMEM, virt_to_phys(&op));
> >> +	rc = rc + 1000;
> >
> > Why the addition?
> 
> If you notice the host patch I had subtracted 1000 while passing the return value
> in the kvm_emulate_hypercall function. This was to avoid the guest kernel panic due to
> the return of a non-negative value by the kvm_hypercall. In order to get the original value
> back I added 1000.

Avi, is there a right way of doing this?
