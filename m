Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1HCILm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:11:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64207 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1HCILe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:11:34 -0400
Message-ID: <4E3902C7.9050907@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 16:11:51 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
References: <4E38C314.8070305@cn.fujitsu.com> <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com>
In-Reply-To: <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 16:10:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 16:10:29
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-8-3 15:38, Shaohua Li wrote:
> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>> Hi,
>>
>> I ran a fio test to simulate qemu-kvm io behaviour.
>> When job number is greater than 2, IO performance is
>> really bad.
>>
>> 1 thread: aggrb=15,129KB/s
>> 4 thread: aggrb=1,049KB/s
>>
>> Kernel: lastest upstream
>>
>> Any idea?
>>
>> ---
>> [global]
>> runtime=30
>> time_based=1
>> size=1G
>> group_reporting=1
>> ioengine=posixaio
>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
>> thread=1
>>
>> [kvmio-1]
>> description=kvmio-1
>> numjobs=4
>> rw=write
>> bs=4k
>> direct=1
>> filename=/mnt/sda4/1G.img
> Hmm, the test runs always about 15M/s at my side regardless how many threads.

CFQ？
what's the slice_idle value?

Thanks,
Gui

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


