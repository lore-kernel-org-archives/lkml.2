Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0IWL2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:28:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:58065 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab0IWL2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:28:40 -0400
Message-ID: <4C9B39DC.8050409@kernel.org>
Date: Thu, 23 Sep 2010 13:28:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ida: document IDA_BITMAP_LONGS calculation
References: <1283506698-21369-1-git-send-email-namhyung@gmail.com> <alpine.LNX.2.00.1009231325370.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009231325370.26813@pobox.suse.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 11:28:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 01:25 PM, Jiri Kosina wrote:
> On Fri, 3 Sep 2010, Namhyung Kim wrote:
> 
>> IDA_BITMAP_LONGS value is calculated take into account struct ida_bitmap
>> not to waste memory space. Comment it.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Acked-by: Tejun Heo <tj@kernel.org>
>> ---
>>  include/linux/idr.h |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/idr.h b/include/linux/idr.h
>> index e968db7..3f4b718 100644
>> --- a/include/linux/idr.h
>> +++ b/include/linux/idr.h
>> @@ -117,10 +117,13 @@ void idr_init(struct idr *idp);
>>  /*
>>   * IDA - IDR based id allocator, use when translation from id to
>>   * pointer isn't necessary.
>> + *
>> + * IDA_BITMAP_LONGS is calculated to be one less to accommodate
>> + * ida_bitmap->nr_busy so that the whole struct fits in 128 bytes.
>>   */
>>  #define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
>>  #define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
>> -#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
>> +#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
>>  
>>  struct ida_bitmap {
>>  	long			nr_busy;
> 
> Tejun, any word on this patch? Doesn't seem to be present in linux-next.

Ooh, I was hoping this one could go through the trivial tree.  It
would be great if you can pick up the patch.

Thank you.

-- 
tejun
