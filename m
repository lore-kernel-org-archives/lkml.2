Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0K2CfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:35:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0K2CfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:35:22 -0500
Message-ID: <4CF31157.6020905@cn.fujitsu.com>
Date: Mon, 29 Nov 2010 10:35:03 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/8] cfq-iosched: Enable deep hierarchy in CGgroup
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9D06.6070800@cn.fujitsu.com> <20101115195428.GE3396@redhat.com>
In-Reply-To: <20101115195428.GE3396@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-29 10:35:33,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-29 10:35:34,
	Serialize complete at 2010-11-29 10:35:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Sun, Nov 14, 2010 at 04:25:42PM +0800, Gui Jianfeng wrote:
>> Currenlty, only level 0 and 1 CGroup directory is allowed to be created.
>> This patch enables deep hierarchy in CGgroup.
>>
> 
> I also had posted the patch. Today Jens applied it to
> origin/for-2.6.38/rc2-holder and after -rc2 will move to 2.6.38/core. At
> that point of time you can drop this patch from the series.
> 

Ok.

Gui

> Vivek
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/blk-cgroup.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index b1febd0..455768a 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -1452,10 +1452,6 @@ blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>>  		goto done;
>>  	}
>>  
>> -	/* Currently we do not support hierarchy deeper than two level (0,1) */
>> -	if (parent != cgroup->top_cgroup)
>> -		return ERR_PTR(-EPERM);
>> -
>>  	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
>>  	if (!blkcg)
>>  		return ERR_PTR(-ENOMEM);
>> -- 
>> 1.6.5.2
>>
>>
>>
> 
