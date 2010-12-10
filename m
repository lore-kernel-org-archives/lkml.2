Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0LJLMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:12:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:38796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab0LJLMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:12:48 -0500
Message-ID: <4D020B44.1040600@kernel.org>
Date: Fri, 10 Dec 2010 12:13:08 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 14/16] x86: Unify CPU -> NUMA node mapping between 32
 and 64bit
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-15-git-send-email-tj@kernel.org> <alpine.LFD.2.00.1012092244520.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012092244520.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 11:12:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 10:49 PM, Thomas Gleixner wrote:
> On Sat, 27 Nov 2010, Tejun Heo wrote:
> 
>> Unlike 64bit, 32bit has been using its own cpu_to_node_map[] for CPU
>> -> NUMA node mapping.  Replace it with early_percpu variable
>> x86_cpu_to_node_map and share the mapping code with 64bit.
>>
>> * USE_PERCPU_NUMA_NODE_ID is now enabled for 32bit too.
>>
>> * x86_cpu_to_node_map and numa_set/clear_node() are moved from numa_64
>>   to numa.  For now, x86_cpu_to_node_map is initialized with 0 instead
>>   of NUMA_NO_NODE.  This is to avoid introducing unexpected behavior
> 
> That's true for 32bit only, right? I actually had to dig into the code
> to verify this. Please make this clear for the casual reader.

Will do so.

Thanks.

-- 
tejun
