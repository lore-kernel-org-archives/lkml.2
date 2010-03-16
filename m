Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937584Ab0CPJGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:06:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934606Ab0CPJGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:06:11 -0400
Message-ID: <4B9F49F1.70202@redhat.com>
Date: Tue, 16 Mar 2010 11:05:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: balbir@linux.vnet.ibm.com, KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315091720.GC18054@balbir.in.ibm.com> <4B9DFD9C.8030608@redhat.com> <4B9E810E.9010706@codemonkey.ws>
In-Reply-To: <4B9E810E.9010706@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 08:48 PM, Anthony Liguori wrote:
> On 03/15/2010 04:27 AM, Avi Kivity wrote:
>>
>> That's only beneficial if the cache is shared.  Otherwise, you could 
>> use the balloon to evict cache when memory is tight.
>>
>> Shared cache is mostly a desktop thing where users run similar 
>> workloads.  For servers, it's much less likely.  So a modified-guest 
>> doesn't help a lot here.
>
> Not really.  In many cloud environments, there's a set of common 
> images that are instantiated on each node.  Usually this is because 
> you're running a horizontally scalable application or because you're 
> supporting an ephemeral storage model.

But will these servers actually benefit from shared cache?  So the 
images are shared, they boot up, what then?

- apache really won't like serving static files from the host pagecache
- dynamic content (java, cgi) will be mostly in anonymous memory, not 
pagecache
- ditto for application servers
- what else are people doing?

> In fact, with ephemeral storage, you typically want to use 
> cache=writeback since you aren't providing data guarantees across 
> shutdown/failure.

Interesting point.

We'd need a cache=volatile for this use case to avoid the fdatasync()s 
we do now.  Also useful for -snapshot.  In fact I have a patch for this 
somewhere I can dig out.

-- 
error compiling committee.c: too many arguments to function

