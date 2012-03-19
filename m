Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032074Ab2CSR4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:56:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2CSR4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:56:41 -0400
Message-ID: <4F677351.5000908@redhat.com>
Date: Mon, 19 Mar 2012 19:56:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Akshay Karle <akshay.a.karle@gmail.com>, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>, kvm@vger.kernel.org,
        ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 2/2] kvm: guest-side changes for tmem on KVM
References: <1331226157.2585.33.camel@aks> <20120315170316.GM30250@phenom.dumpdata.com> <1331874035.2790.5.camel@aks> <20120319174954.GD5063@phenom.dumpdata.com>
In-Reply-To: <20120319174954.GD5063@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 07:49 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Mar 16, 2012 at 10:30:35AM +0530, Akshay Karle wrote:
> > >> +/* kvm tmem foundation ops/hypercalls */
> > >> +
> > >> +static inline int kvm_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
> > >> +	u32 index, u32 tmem_offset, u32 pfn_offset, unsigned long pfn, u32 len, uint16_t cli_id)
> > >
> > > That is rather long list of arguments. Could you pass in a structure instead?
> > >
> > > Are you actually using all of the arguments in every call?
> > 
> > For different functions different parameters are used. If we want to reduce the number of arguments,
> > the tmem_ops structure can be created in the functions calling kvm_tmem_op instead of creating it here
> > and that can be passed, will make these changes in the next patch.
> > 
> > >> +{
> > >> +	struct tmem_ops op;
> > >> +	int rc = 0;
> > >> +	op.cmd = tmem_cmd;
> > >> +	op.pool_id = tmem_pool;
> > >> +	op.u.gen.oid[0] = oid.oid[0];
> > >> +	op.u.gen.oid[1] = oid.oid[1];
> > >> +	op.u.gen.oid[2] = oid.oid[2];
> > >> +	op.u.gen.index = index;
> > >> +	op.u.gen.tmem_offset = tmem_offset;
> > >> +	op.u.gen.pfn_offset = pfn_offset;
> > >> +	op.u.gen.pfn = pfn;
> > >> +	op.u.gen.len = len;
> > >> +	op.u.gen.cli_id = cli_id;
> > >> +	rc = kvm_hypercall1(KVM_HC_TMEM, virt_to_phys(&op));
> > >> +	rc = rc + 1000;
> > >
> > > Why the addition?
> > 
> > If you notice the host patch I had subtracted 1000 while passing the return value
> > in the kvm_emulate_hypercall function. This was to avoid the guest kernel panic due to
> > the return of a non-negative value by the kvm_hypercall. In order to get the original value
> > back I added 1000.
>
> Avi, is there a right way of doing this?

Why would the guest kernel panic due to the return of a non-negative value?

-- 
error compiling committee.c: too many arguments to function

