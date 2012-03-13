Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2CMRdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:33:33 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49260 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059Ab2CMRdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:33:31 -0400
Message-ID: <4F5F847C.3060505@parallels.com>
Date: Tue, 13 Mar 2012 21:31:40 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <ssouhlal@FreeBSD.org>, <cgroups@vger.kernel.org>,
        <suleiman@google.com>, <penberg@kernel.org>, <cl@linux.com>,
        <yinghan@google.com>, <hughd@google.com>, <peterz@infradead.org>,
        <dan.magenheimer@oracle.com>, <hannes@cmpxchg.org>, <mgorman@suse.de>,
        <James.Bottomley@HansenPartnership.com>, <linux-mm@kvack.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>,
        <rientjes@google.com>
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting infrastructure.
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org> <4F5C5E54.2020408@parallels.com> <20120313152446.28b0d696.kamezawa.hiroyu@jp.fujitsu.com> <4F5F236A.1070609@parallels.com> <xr93d38g77w5.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr93d38g77w5.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 09:00 PM, Greg Thelen wrote:
> Glauber Costa<glommer@parallels.com>  writes:
>> 2) For the kernel itself, we are mostly concerned that a malicious container may
>> pin into memory big amounts of kernel memory which is, ultimately,
>> unreclaimable. In particular, with overcommit allowed scenarios, you can fill
>> the whole physical memory (or at least a significant part) with those objects,
>> well beyond your softlimit allowance, making the creation of further containers
>> impossible.
>> With user memory, you can reclaim the cgroup back to its place. With kernel
>> memory, you can't.
>
> In overcommit situations the page allocator starts failing even though
> memcg page can charge pages.
If you overcommit mem+swap, yes. If you overcommit mem, no: reclaim 
happens first. And we don't have that option with pinned kernel memory.

Of course you *can* run your system without swap, but the whole thing 
exists exactly because there is a large enough # of ppl who wants to be 
able to overcommit their physical memory, without failing allocations.

