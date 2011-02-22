Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1BVQsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:48:18 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33546 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab1BVQsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:48:14 -0500
Message-ID: <4D63E8C9.4060009@linux.vnet.ibm.com>
Date: Tue, 22 Feb 2011 08:48:09 -0800
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v9fs tree
References: <20110222115340.da48b908.sfr@canb.auug.org.au> <4D63479F.3060603@linux.vnet.ibm.com> <20110222163016.aac65a7a.sfr@canb.auug.org.au> <4D635618.3@linux.vnet.ibm.com> <AANLkTik1cmehfLENCYb8GYPLbM6PWUCzqtp74xD2YbVR@mail.gmail.com>
In-Reply-To: <AANLkTik1cmehfLENCYb8GYPLbM6PWUCzqtp74xD2YbVR@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2011 6:57 AM, Eric Van Hensbergen wrote:
> JV - you should be able to check this just by building with allmod
> config.  I'll accept a pull immediately if this is the fix.

Yeah; it works fine with this patch.

Thanks,
JV

> 
>         -eric
> 
> 
> On Tue, Feb 22, 2011 at 12:22 AM, Venkateswararao Jujjuri (JV)
> <jvrao@linux.vnet.ibm.com> wrote:
>> On 2/21/2011 9:30 PM, Stephen Rothwell wrote:
>>> Hi,
>>>
>>> On Mon, 21 Feb 2011 21:20:31 -0800 "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com> wrote:
>>>>
>>>> On 2/21/2011 4:53 PM, Stephen Rothwell wrote:
>>>>>
>>>>> After merging the v9fs tree, today's linux-next build (x86_64
>>>>> allmodconfig) failed like this:
>>>>>
>>>>> ERROR: "p9_payload_gup" [net/9p/9pnet_virtio.ko] undefined!
>>>>> ERROR: "p9_nr_pages" [net/9p/9pnet_virtio.ko] undefined!
>>>>> ERROR: "p9_release_req_pages" [net/9p/9pnet_virtio.ko] undefined!
>>>>
>>>> These functions are defined by commit 249951bf66816128a7698caa826425e299494c82
>>>> ([net/9p] Preparation and helper functions for zero copy)
>>>
>>> Yes, they are - but they are not exported to modules.
>>
>> Thanks; Can you please check if this patch fixes your issue?
>>
>> diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
>> index ca705f1..da7c2cd 100644
>> --- a/net/9p/trans_common.c
>> +++ b/net/9p/trans_common.c
>> @@ -13,6 +13,7 @@
>>  */
>>
>>  #include <linux/slab.h>
>> + #include <linux/module.h>
>>  #include <net/9p/9p.h>
>>  #include <net/9p/client.h>
>>  #include <linux/scatterlist.h>
>> @@ -32,6 +33,7 @@ p9_release_req_pages(struct trans_rpage_info *rpinfo)
>>                i++;
>>        }
>>  }
>> +EXPORT_SYMBOL(p9_release_req_pages);
>>
>>  /**
>>  * p9_nr_pages - Return number of pages needed to accomodate the payload.
>> @@ -45,6 +47,7 @@ p9_nr_pages(struct p9_req_t *req)
>>                        PAGE_SIZE - 1) >> PAGE_SHIFT;
>>        return end_page - start_page;
>>  }
>> +EXPORT_SYMBOL(p9_nr_pages);
>>
>>  /**
>>  * payload_gup - Translates user buffer into kernel pages and
>> @@ -91,3 +94,4 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *p
>>        }
>>        return 0;
>>  }
>> +EXPORT_SYMBOL(p9_payload_gup);
>>
>>
>>
>>


