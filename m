Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1JCMUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:20:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57659 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab1JCMUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:20:31 -0400
Message-ID: <4E89A846.1010200@parallels.com>
Date: Mon, 3 Oct 2011 16:19:18 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <avagin@parallels.com>
Subject: Re: [PATCH v4 7/8] Display current tcp memory allocation in kmem
 cgroup
References: <1317637123-18306-1-git-send-email-glommer@parallels.com> <1317637123-18306-8-git-send-email-glommer@parallels.com> <20111003121446.GD29312@shutemov.name>
In-Reply-To: <20111003121446.GD29312@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 04:14 PM, Kirill A. Shutemov wrote:
> On Mon, Oct 03, 2011 at 02:18:42PM +0400, Glauber Costa wrote:
>> This patch introduces kmem.tcp_current_memory file, living in the
>> kmem_cgroup filesystem. It is a simple read-only file that displays the
>> amount of kernel memory currently consumed by the cgroup.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Eric W. Biederman<ebiederm@xmission.com>
>> ---
>>   Documentation/cgroups/memory.txt |    1 +
>>   mm/memcontrol.c                  |   11 +++++++++++
>>   2 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
>> index 1ffde3e..f5a539d 100644
>> --- a/Documentation/cgroups/memory.txt
>> +++ b/Documentation/cgroups/memory.txt
>> @@ -79,6 +79,7 @@ Brief summary of control files.
>>    memory.independent_kmem_limit	 # select whether or not kernel memory limits are
>>   				   independent of user limits
>>    memory.kmem.tcp.max_memory      # set/show hard limit for tcp buf memory
>> + memory.kmem.tcp.current_memory  # show current tcp buf memory allocation
>
> Both are in pages, right?
> Shouldn't it be scaled to bytes and named uniform with other memcg file?
> memory.kmem.tcp.limit_in_bytes/usage_in_bytes.
>
You are absolutely correct.
Since the internal tcp comparison works, I just ended up never noticing 
this.

Thanks.

