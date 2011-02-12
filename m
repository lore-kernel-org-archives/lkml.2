Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1BLSEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 13:04:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17037 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1BLSEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 13:04:35 -0500
Message-ID: <4D56CB9F.8030909@kernel.org>
Date: Sat, 12 Feb 2011 10:04:15 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in
 acpi_numa_memory_affinity_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org>	<1297530663-26234-3-git-send-email-tj@kernel.org>	<4D56C79B.2060201@kernel.org> <AANLkTimiKA91OEMyt-KM5q5V5s6-xS_76Ji-Y8M_k4Bt@mail.gmail.com>
In-Reply-To: <AANLkTimiKA91OEMyt-KM5q5V5s6-xS_76Ji-Y8M_k4Bt@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D56CBA7.0185,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 09:56 AM, Tejun Heo wrote:
> On Sat, Feb 12, 2011 at 6:47 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> -             if ((nd->start | nd->end) == 0)
>>> -                     node_clear(node, nodes_parsed);
>>
>> after change
>> looks like nodes_parsed is not set anymore for node that only have hotplug memory.
> 
> Yeap, which matches the above node_clear().  If the node was already
> occupied, the bit would already be set.  If not, the above
> node_clear() would clear it, so the same result.  The code was quite
> convoluted.

no. if the node only have hotplug mem.
then nd->start and nd->end will be set to that hot plug range.
and old code does not clear nodes_parsed...

Yinghai
