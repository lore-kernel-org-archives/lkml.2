Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab3AJHOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:14:20 -0500
Received: from mx2.parallels.com ([64.131.90.16]:40086 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab3AJHOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:14:17 -0500
Message-ID: <50EE6A48.7060307@parallels.com>
Date: Thu, 10 Jan 2013 11:14:16 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <rientjes@google.com>,
        <len.brown@intel.com>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <cl@linux.com>, <minchan.kim@gmail.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <wujianguo@huawei.com>, <wency@cn.fujitsu.com>, <hpa@zytor.com>,
        <linfeng@cn.fujitsu.com>, <laijs@cn.fujitsu.com>, <mgorman@suse.de>,
        <yinghai@kernel.org>, <x86@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-acpi@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <cmetcalf@tilera.com>, <sparclinux@vger.kernel.org>
Subject: Re: [PATCH v6 00/15] memory-hotplug: hot-remove physical memory
References: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com> <20130109142314.1ce04a96.akpm@linux-foundation.org> <50EE24A4.8020601@cn.fujitsu.com>
In-Reply-To: <50EE24A4.8020601@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 06:17 AM, Tang Chen wrote:
>>> Note: if the memory provided by the memory device is used by the
>>> kernel, it
>>> can't be offlined. It is not a bug.
>>
>> Right.  But how often does this happen in testing?  In other words,
>> please provide an overall description of how well memory hot-remove is
>> presently operating.  Is it reliable?  What is the success rate in
>> real-world situations?
> 
> We test the hot-remove functionality mostly with movable_online used.
> And the memory used by kernel is not allowed to be removed.

Can you try doing this using cpusets configured to hardwall ?
It is my understanding that the object allocators will try hard not to
allocate anything outside the walls defined by cpuset. Which means that
if you have one process per node, and they are hardwalled, your kernel
memory will be spread evenly among the machine. With a big enough load,
they should eventually be present in all blocks.

Another question I have for you: Have you considering calling
shrink_slab to try to deplete the caches and therefore free at least
slab memory in the nodes that can't be offlined? Is it relevant?
