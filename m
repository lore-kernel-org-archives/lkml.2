Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1CGBub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 20:50:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57518 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1CGBua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 20:50:30 -0500
Message-ID: <4D743667.70807@cn.fujitsu.com>
Date: Mon, 07 Mar 2011 09:35:35 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Fix update_vdisktime logic
References: <4D3E4317.80406@cn.fujitsu.com> <20110125212656.GF10664@redhat.com>
In-Reply-To: <20110125212656.GF10664@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 09:43:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 09:49:16,
	Serialize complete at 2011-03-07 09:49:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Tue, Jan 25, 2011 at 11:27:19AM +0800, Gui Jianfeng wrote:
>> The update_vdisktime logic is broken since commit b54ce60eb7f61f8e314b8b241b0469eda3bb1d42,
>> st->min_vdisktime never makes a progress. Fix it.
>>
>> Thanks Vivek for pointing it out.
>>
>> Signed-off-by: Gui Jianfeng <guijianfen@cn.fujitsu.com>
> 
> Thanks Gui. Looks good to me.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Jens, Would you pick up this fix?

Thanks,
Gui

> 
> Thanks
> Vivek
> 
>> ---
>>  block/cfq-iosched.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index f083bda..8c28f56 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -558,15 +558,13 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
>>  
>>  static void update_min_vdisktime(struct cfq_rb_root *st)
>>  {
>> -	u64 vdisktime = st->min_vdisktime;
>>  	struct cfq_group *cfqg;
>>  
>>  	if (st->left) {
>>  		cfqg = rb_entry_cfqg(st->left);
>> -		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
>> +		st->min_vdisktime = max_vdisktime(st->min_vdisktime,
>> +						  cfqg->vdisktime);
>>  	}
>> -
>> -	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
>>  }
>>  
>>  /*
>> -- 
>> 1.7.1
> 
