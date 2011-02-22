Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1BVTbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:31:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16408 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab1BVTbP (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Feb 2011 14:31:15 -0500
Date: Tue, 22 Feb 2011 14:31:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy.Fitzhardinge@citrix.com
Subject: Re: [PATCH 5/7] xen: PV on HVM: support PV spinlocks
Message-ID: <20110222193104.GC17866@dumpdata.com>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
 <1297878787-378-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297878787-378-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D640EFD.0099:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void xen_hvm_spinlock_init(void)
> +{
> +	if (!xen_have_vector_callback)
> +		return;
> +	xen_init_lock_cpu(0);
> +	xen_init_spinlocks();
> +}
> +
> +static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +	native_smp_prepare_cpus(max_cpus);
> +	xen_hvm_spinlock_init();
> +}

You could squash those two together. Ah, next patch does something interesting.
