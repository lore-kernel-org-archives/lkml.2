Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1IPRxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:53:00 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:47863 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1IPRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:52:58 -0400
Message-ID: <4E738CF6.4020808@vflare.org>
Date: Fri, 16 Sep 2011 13:52:54 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, Greg KH <greg@kroah.com>,
        gregkh@suse.de, devel@driverdev.osuosl.org, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        linux-mm@kvack.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org> <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org> <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org 4E72284B.2040907@linux.vnet.ibm.com> <075c4e4c-a22d-47d1-ae98-31839df6e722@default> <4E725109.3010609@linux.vnet.ibm.com>
In-Reply-To: <4E725109.3010609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 03:24 PM, Seth Jennings wrote:

> On 09/15/2011 12:29 PM, Dan Magenheimer wrote:
>>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>>> Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
>>>


>>
>> Seth, I am still not clear why it is not possible to support
>> either allocation algorithm, selectable at runtime.  Or even
>> dynamically... use xvmalloc to store well-compressible pages
>> and xcfmalloc for poorly-compressible pages.  I understand
>> it might require some additional coding, perhaps even an
>> ugly hack or two, but it seems possible.
> 
> But why do an ugly hack if we can just use a single allocator
> that has the best overall performance for the allocation range
> the zcache requires.  Why make it more complicated that it
> needs to be?
> 
>>


I agree with Seth here: a mix of different allocators for the (small)
range of sizes which zcache requires, looks like a bad idea to me.
Maintaining two allocators is a pain and this will also complicate
future plans like compaction etc.

Thanks,
Nitin

