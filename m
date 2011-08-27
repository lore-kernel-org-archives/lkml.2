Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1H0JfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 05:35:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37933 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1H0JfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 05:35:14 -0400
Message-ID: <4E58BA41.6050503@gmail.com>
Date: Sat, 27 Aug 2011 17:34:57 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: wanlong.gao@gmail.com
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: fix size computation according to the definition
 of struct vring_used in vring_size
References: <4E584365.1010806@gmail.com> <1314413399.1913.1.camel@Allen>
In-Reply-To: <1314413399.1913.1.camel@Allen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年08月27日 10:49, Wanlong Gao wrote:
> On Sat, 2011-08-27 at 09:07 +0800, Wang Sheng-Hui wrote:
>> The patch is against 3.1-rc3.
>>
>> struct vring_used has two __u16 fields plus array of struct vring_used_elem.
>> Current vring_size counts the __u16 fields to 3. Fix it to 2 in the patch.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  include/linux/virtio_ring.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
>> index 4a32cb6..fcda152 100644
>> --- a/include/linux/virtio_ring.h
>> +++ b/include/linux/virtio_ring.h
>> @@ -143,7 +143,7 @@ static inline unsigned vring_size(unsigned int num, unsigned long align)
>>  {
>>  	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
>>  		 + align - 1) & ~(align - 1))
>> -		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
>> +		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
>>  }
>>  
>>  /* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
> 
> Hi:
> I'm not deep into it, but I think you can see this:
> http://marc.info/?l=git-commits-head&m=130687915816130&w=2
> 
> Thanks
> -Wanlong Gao
> 

Thanks.

I checked the comments, and think we should patch vring_init
and vring_size according to the layout description in the comments.
Right?
