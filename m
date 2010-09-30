Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab0I3PR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:17:59 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41291 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab0I3PR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:17:58 -0400
Message-ID: <4CA4AA21.9030109@austin.ibm.com>
Date: Thu, 30 Sep 2010 10:17:53 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] v2 De-Couple sysfs memory directories from memory
 sections
References: <4CA0EBEB.1030204@austin.ibm.com> <20100928123848.GH14068@sgi.com> <4CA2313D.2030508@austin.ibm.com> <20100929192830.GK14068@sgi.com>
In-Reply-To: <20100929192830.GK14068@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 02:28 PM, Robin Holt wrote:
> On Tue, Sep 28, 2010 at 01:17:33PM -0500, Nathan Fontenot wrote:
>> On 09/28/2010 07:38 AM, Robin Holt wrote:
>>> I was tasked with looking at a slowdown in similar sized SGI machines
>>> booting x86_64.  Jack Steiner had already looked into the memory_dev_init.
>>> I was looking at link_mem_sections().
>>>
>>> I made a dramatic improvement on a 16TB machine in that function by
>>> merely caching the most recent memory section and checking to see if
>>> the next memory section happens to be the subsequent in the linked list
>>> of kobjects.
>>>
>>> That simple cache reduced the time for link_mem_sections from 1 hour 27
>>> minutes down to 46 seconds.
>>
>> Nice!
>>
>>>
>>> I would like to propose we implement something along those lines also,
>>> but I am currently swamped.  I can probably get you a patch tomorrow
>>> afternoon that applies at the end of this set.
>>
>> Should this be done as a separate patch?  This patch set concentrates on
>> updates to the memory code with the node updates only being done due to the
>> memory changes.
>>
>> I think its a good idea to do the caching and have no problem adding on to
>> this patchset if no one else has any objections.
> 
> I am sorry.  I had meant to include you on the Cc: list.  I just posted a
> set of patches (3 small patches) which implement the cache most recent bit
> I aluded to above.  Search for a subject of "Speed up link_mem_sections
> during boot" and you will find them.  I did add you to the Cc: list for
> the next time I end up sending the set.
> 
> My next task is to implement a x86_64 SGI UV specific chunk of code
> to memory_block_size_bytes().  Would you consider adding that to your
> patch set?  I expect to have that either later today or early tomorrow.
> 

No problem. I'm putting together a new patch set with updates from all of
the comments now so go ahead and send it to me when you have it ready.

-Nathan
