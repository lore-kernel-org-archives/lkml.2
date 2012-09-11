Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2IKFEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:04:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37492 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2IKFEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120911021051.GB22077@localhost>
References: <1346083301-3545-1-git-send-email-linkinjeon@gmail.com>
	<20120911021051.GB22077@localhost>
Date: Tue, 11 Sep 2012 14:04:46 +0900
Message-ID: <CAKYAXd8M+V5v2ZuU-cV8CYPa4VyOTqOeNuWg7ufMVsSqwNBdsw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Documentation: add description of dirty_background_time
From: Namjae Jeon <linkinjeon@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Wu.

I will update documentation as per your suggestion.
Thank you.

2012/9/11, Fengguang Wu <fengguang.wu@intel.com>:
> On Mon, Aug 27, 2012 at 12:01:41PM -0400, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This commit adds dirty_background_time description in bdi sysfs
>> documentation.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
>> ---
>>  Documentation/ABI/testing/sysfs-class-bdi |   13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-class-bdi
>> b/Documentation/ABI/testing/sysfs-class-bdi
>> index 5f50097..018e26a 100644
>> --- a/Documentation/ABI/testing/sysfs-class-bdi
>> +++ b/Documentation/ABI/testing/sysfs-class-bdi
>> @@ -48,3 +48,16 @@ max_ratio (read-write)
>>  	most of the write-back cache.  For example in case of an NFS
>>  	mount that is prone to get stuck, or a FUSE mount which cannot
>>  	be trusted to play fair.
>> +
>> +dirty_background_time (read-write)
>> +
>> +	It is used to start early writeback of given bdi once bdi dirty
>> +	data exceeds product of average write bandwidth and
>> +	dirty_background_time.
>
> It may be worth to note that it works _in parallel with_ the global
> background writeback threshold rather than replacing it.
>
>> It is mainly useful for tuning writeback
>> +	speed at 'NFS Server' so that NFS client could see better write speed.
>
> Hopefully more clear:
>
> A good use case is setting it to around 100 (1 second) in the NFS
> server for improving NFS write performance. Note that it's not
> recommended to set it to a too small value, which might lead to
> small IO size. Setting it to 0 disables the feature.
>
>> +	However, sometimes it may not match user expectations as it is based
>> +	on bdi write bandwidth estimation.
>
> The users should not expect this threshold to work accurately.
>
>> Write bandwidth estimation is a
>> +	best effort to estimate bdi write speed bandwidth. But it can be
>> +	wildly wrong in certain situations.
>
> such as sudden change of workload (including the workload startup stage),
> or if there are no heavy writes since boot, in which case there is no
> reasonable estimation yet.
>
>> +	dirty_background_time is expressed in msec.
>
> That can be eliminated if changing to dirty_background_centisecs.
>
> Thanks,
> Fengguang
>
