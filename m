Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab1CBUdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:33:46 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51830 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab1CBUdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:33:45 -0500
Message-ID: <4D6EA975.8070200@kernel.org>
Date: Wed, 02 Mar 2011 12:32:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
References: <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org> <20110302102530.GB3319@htj.dyndns.org> <4D6E6D52.8030901@kernel.org> <20110302163729.GQ3319@htj.dyndns.org> <4D6E7459.6050706@kernel.org> <20110302165545.GR3319@htj.dyndns.org> <4D6E91EC.6040906@kernel.org> <20110302190208.GD28266@mtj.dyndns.org> <4D6E9541.2040201@kernel.org> <20110302191338.GE28266@mtj.dyndns.org>
In-Reply-To: <20110302191338.GE28266@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D6EA995.01A5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 11:13 AM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Mar 02, 2011 at 11:06:41AM -0800, Yinghai Lu wrote:
>>> Hmmm?  I can't really follow your sentence.  This is init stage.
>>> Anyways, why can't it just walk over the enabled nodes?  What would be
>>> the difference?
>>
>> my point is that we really not need to go over it if original is not there.
> 
> Oh, you mean if (!phys_dist)?  Yeah yeah sure, I was mostly talking
> about allocating new table separately and returning the count and all
> those things.  Can you just do the phys_dist testing and going over
> enabled nodes?

why use enabled nodes?

numa_alloc_distance already have calculated. with numa_nodes_parsed and numa_meminfo

        /* size the new table and allocate it */
        nodes_parsed = numa_nodes_parsed;
        numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);

        for_each_node_mask(i, nodes_parsed)
                cnt = i;
        cnt++;

