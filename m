Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab1CCWDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:03:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22691 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:03:50 -0500
Message-ID: <4D701015.2040703@kernel.org>
Date: Thu, 03 Mar 2011 14:03:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, brgerst@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org> <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com> <20110221083511.GC31267@htj.dyndns.org> <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com> <4D700B93.2080807@gmail.com> <alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D70102D.0083,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 02:00 PM, David Rientjes wrote:

he want

> +#ifdef CONFIG_ACPI_NUMA
>> > +		ret = numa_init(x86_acpi_numa_init);
>> > +		if (!ret)
>> > +			return;
>> > +#endif
>> > +#ifdef CONFIG_AMD_NUMA
>> > +		ret = numa_init(amd_numa_init);
>> > +		if (!ret)
>> > +			return;
>> > +#endif

to be replaced by:

> +#ifdef CONFIG_ACPI_NUMA
>> > +		if (!numa_init(x86_acpi_numa_init))
>> > +			return;
>> > +#endif
>> > +#ifdef CONFIG_AMD_NUMA
>> > +		if (!numa_init(amd_numa_init))
>> > +			return;
>> > +#endif

