Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2KWB6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:58:53 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55031 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2KWB6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:58:51 -0500
Message-ID: <50AED854.7080300@gmail.com>
Date: Fri, 23 Nov 2012 09:58:44 +0800
From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: metin d <metdos@yahoo.com>
CC: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: Problem in Page Cache Replacement
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com> <20121120182500.GH1408@quack.suse.cz>
In-Reply-To: <20121120182500.GH1408@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 02:25 AM, Jan Kara wrote:
> On Tue 20-11-12 09:42:42, metin d wrote:
>> I have two PostgreSQL databases named data-1 and data-2 that sit on the
>> same machine. Both databases keep 40 GB of data, and the total memory
>> available on the machine is 68GB.
>>
>> I started data-1 and data-2, and ran several queries to go over all their
>> data. Then, I shut down data-1 and kept issuing queries against data-2.
>> For some reason, the OS still holds on to large parts of data-1's pages
>> in its page cache, and reserves about 35 GB of RAM to data-2's files. As
>> a result, my queries on data-2 keep hitting disk.
>>
>> I'm checking page cache usage with fincore. When I run a table scan query
>> against data-2, I see that data-2's pages get evicted and put back into
>> the cache in a round-robin manner. Nothing happens to data-1's pages,
>> although they haven't been touched for days.

Hi metin d,

fincore is a tool or ...? How could I get it?

Regards,
Jaegeuk

>>
>> Does anybody know why data-1's pages aren't evicted from the page cache?
>> I'm open to all kind of suggestions you think it might relate to problem.
>    Curious. Added linux-mm list to CC to catch more attention. If you run
> echo 1 >/proc/sys/vm/drop_caches
>    does it evict data-1 pages from memory?
>
>> This is an EC2 m2.4xlarge instance on Amazon with 68 GB of RAM and no
>> swap space. The kernel version is:
>>
>> $ uname -r
>> 3.2.28-45.62.amzn1.x86_64
>> Edit:
>>
>> and it seems that I use one NUMA instance, if  you think that it can a problem.
>>
>> $ numactl --hardware
>> available: 1 nodes (0)
>> node 0 cpus: 0 1 2 3 4 5 6 7
>> node 0 size: 70007 MB
>> node 0 free: 360 MB
>> node distances:
>> node   0
>>    0:  10
> 								Honza

