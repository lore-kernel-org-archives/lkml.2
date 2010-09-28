Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0I1SVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:21:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44969 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab0I1SVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:21:33 -0400
Message-ID: <4CA231FA.4070907@austin.ibm.com>
Date: Tue, 28 Sep 2010 13:20:42 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/8] v2 Allow memory block to span multiple memory sections
References: <4CA0EBEB.1030204@austin.ibm.com> <4CA0EFAA.8050000@austin.ibm.com> <20100928124810.GI14068@sgi.com>
In-Reply-To: <20100928124810.GI14068@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 07:48 AM, Robin Holt wrote:
>> +u32 __weak memory_block_size_bytes(void)
>> +{
>> +	return MIN_MEMORY_BLOCK_SIZE;
>> +}
>> +
>> +static u32 get_memory_block_size(void)
> 
> Can we make this an unsigned long?  We are testing on a system whose
> smallest possible configuration is 4GB per socket with 512 sockets.
> We would like to be able to specify this as 2GB by default (results
> in the least lost memory) and suggest we add a command line option
> which overrides this value.  We have many installations where 16GB may
> be optimal.  Large configurations will certainly become more prevalent.

Works for me.

> 
> ...
>> @@ -551,12 +608,16 @@
>>  	unsigned int i;
>>  	int ret;
>>  	int err;
>> +	int block_sz;
> 
> This one needs to match the return above.  In our tests, we ended up
> with a negative sections_per_block which caused very unexpected results.

Oh, nice catch.  I'll update both of these.

-Nathan

