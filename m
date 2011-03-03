Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab1CCWFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:05:32 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab1CCWFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:05:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xJl/RcphOmnVH2+C9KAylK2DigPHTReqh8ykwqSOFzoZYrQRZkaKZSUpXerLPj2xQh
         doMxQoNKN/WjDAFw6L0Q==
Date: Thu, 3 Mar 2011 14:05:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, brgerst@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
In-Reply-To: <4D701015.2040703@kernel.org>
Message-ID: <alpine.DEB.2.00.1103031404510.4141@chino.kir.corp.google.com>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org> <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com> <20110221083511.GC31267@htj.dyndns.org> <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com> <4D700B93.2080807@gmail.com>
 <alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com> <4D701015.2040703@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011, Yinghai Lu wrote:

> he want
> 
> > +#ifdef CONFIG_ACPI_NUMA
> >> > +		ret = numa_init(x86_acpi_numa_init);
> >> > +		if (!ret)
> >> > +			return;
> >> > +#endif
> >> > +#ifdef CONFIG_AMD_NUMA
> >> > +		ret = numa_init(amd_numa_init);
> >> > +		if (!ret)
> >> > +			return;
> >> > +#endif
> 
> to be replaced by:
> 
> > +#ifdef CONFIG_ACPI_NUMA
> >> > +		if (!numa_init(x86_acpi_numa_init))
> >> > +			return;
> >> > +#endif
> >> > +#ifdef CONFIG_AMD_NUMA
> >> > +		if (!numa_init(amd_numa_init))
> >> > +			return;
> >> > +#endif

It's a matter of style and I think it's up to Ingo what he'd prefer to 
see.
