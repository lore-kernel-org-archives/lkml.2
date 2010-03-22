Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0CVVHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:07:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0CVVHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:07:31 -0400
Message-ID: <4BA7DBFB.8000808@redhat.com>
Date: Mon, 22 Mar 2010 23:07:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Chris Webb <chris@arachsys.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9EC60A.2070101@codemonkey.ws> <20100317151409.GY31148@arachsys.com> <4BA0FB83.1010502@codemonkey.ws> <20100317162711.GK1997@arachsys.com> <20100322210448.GA12635@arachsys.com>
In-Reply-To: <20100322210448.GA12635@arachsys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 11:04 PM, Chris Webb wrote:
> Chris Webb<chris@arachsys.com>  writes:
>
>    
>> Okay. What I was driving at in describing these systems as 'already broken'
>> is that they will already lose data (in this sense) if they're run on bare
>> metal with normal commodity SATA disks with their 32MB write caches on. That
>> configuration surely describes the vast majority of PC-class desktops and
>> servers!
>>
>> If I understand correctly, your point here is that the small cache on a real
>> SATA drive gives a relatively small time window for data loss, whereas the
>> worry with cache=writeback is that the host page cache can be gigabytes, so
>> the time window for unsynced data to be lost is potentially enormous.
>>
>> Isn't the fix for that just forcing periodic sync on the host to bound-above
>> the time window for unsynced data loss in the guest?
>>      
> For the benefit of the archives, it turns out the simplest fix for this is
> already implemented as a vm sysctl in linux. Set vm.dirty_bytes to 32<<20,
> and the size of dirty page cache is bounded above by 32MB, so we are
> simulating exactly the case of a SATA drive with a 32MB writeback-cache.
>
> Unless I'm missing something, the risk to guest OSes in this configuration
> should therefore be exactly the same as the risk from running on normal
> commodity hardware with such drives and no expensive battery-backed RAM.
>    

A host crash will destroy your data.  If  your machine is connected to a 
UPS, only a firmware crash can destroy your data.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

