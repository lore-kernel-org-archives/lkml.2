Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2JJKEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:04:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61719 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab2JJKEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:04:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,565,1344182400"; 
   d="scan'208";a="5976639"
Message-ID: <50754981.80900@cn.fujitsu.com>
Date: Wed, 10 Oct 2012 18:10:09 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Rientjes <rientjes@google.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>		 <1349780256.7880.12.camel@twins>		 <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>		 <1349815676.7880.85.camel@twins>		 <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>	 <1349860216.7880.105.camel@twins> <507540F5.7040501@cn.fujitsu.com> <1349862694.7880.114.camel@twins>
In-Reply-To: <1349862694.7880.114.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 18:04:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 18:04:24,
	Serialize complete at 2012/10/10 18:04:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/10/2012 05:51 PM, Peter Zijlstra Wrote:
> On Wed, 2012-10-10 at 17:33 +0800, Wen Congyang wrote:
>>
>> Hmm, if per-cpu memory is preserved, and we can't offline and remove
>> this memory. So we can't offline the node.
>>
>> But, if the node is hot added, and per-cpu memory doesn't use the
>> memory on this node. We can hotremove cpu/memory on this node, and then
>> offline this node.
>>
>> Before the cpu is hotadded, cpu's node is -1. We set cpu<->node mapping
>> when it is hotadded. So the entire cpu<->node mapping was not invariant
>> during hotplug.
>>
>> So it is why I try to clear it when the cpu is hot-removed.
>>
>> As we need the mapping to migrate a task to the cpu on the same node first,
>> I think we can clear the mapping when the node is offlined.
> 
> Hmm maybe, but hardware that can hot-add is rare and nobody has it so
> nobody cares ;-)

Yes, nobody cares it now. But we have a such hardware, so I care it now.

> 
> But by clearing cpu_to_node on every hotplug you change semantics for
> all hardware and everybody gets to feel the pain.
> 
> I'm not saying you cannot change things, I'm only saying you should be
> far more careful about it, not change it and wait for things to break.
> Put in some effort to find things that might break and warn people --
> sure, you'll always miss some, and that's ok.

I use ./scripts/get_maintainer.pl, and it doesn't tell me that I should cc
you when I post that patch.


