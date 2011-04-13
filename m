Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1DMS1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:27:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:31059 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab1DMS1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,205,1301900400"; 
   d="scan'208";a="909126155"
Message-ID: <4DA5EAE4.2060406@linux.intel.com>
Date: Wed, 13 Apr 2011 11:26:44 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: stefano.stabellini@eu.citrix.com
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, jeremy@goop.org, yinghai@kernel.org,
        mingo@elte.hu, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86,xen: introduce x86_init.mapping.pagetable_reserve
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 04:19 AM, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Introduce a new x86_init hook called pagetable_reserve that during the
> initial memory mapping is used to reserve a range of memory addresses for
> kernel pagetable usage.
> 
> On native it just calls memblock_x86_reserve_range while on xen it also
> takes care of setting the spare memory previously allocated
> for kernel pagetable pages from RO to RW, so that it can be used for
> other purposes.
> 

What are the *semantics* of this hook?

Hooks are insanely nasty if they are just defined by a particular code
flow, as evidenced by the royal mess called paravirt_ops.

	-hpa
