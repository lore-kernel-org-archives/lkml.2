Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1L2GLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 01:11:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab1L2GLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 01:11:00 -0500
Message-ID: <4EFC0435.3020908@cn.fujitsu.com>
Date: Thu, 29 Dec 2011 14:09:57 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug in BLKBSZSET/GET ioctl ?
References: <4EFBE3D1.5030608@cn.fujitsu.com> <20111229042010.GA22132@localhost> <4EFBEC7C.4060902@cn.fujitsu.com> <20111229044058.GA25524@localhost>
In-Reply-To: <20111229044058.GA25524@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 14:10:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 14:10:09,
	Serialize complete at 2011-12-29 14:10:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 12:40 PM, Wu Fengguang wrote:

> On Thu, Dec 29, 2011 at 12:28:44PM +0800, Wanlong Gao wrote:
>> On 12/29/2011 12:20 PM, Wu Fengguang wrote:
>>
>>> On Thu, Dec 29, 2011 at 11:51:45AM +0800, Wanlong Gao wrote:
>>>> Hi all:
>>>>
>>>> This is first reported to *libguestfs*: https://bugzilla.redhat.com/show_bug.cgi?id=624335
>>>>
>>>> Then, I looked into upstream util-linux and it seems nothing wrong. I'm not convinced that it's a kernel bug.
>>>>
>>>> produce:
>>>>
>>>> ---
>>>> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
>>>> 4096
>>>> # ./util-linux/disk-utils/blockdev --setbsz 2048 /dev/sda6
>>>> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
>>>> 4096
>>>> # ./util-linux/disk-utils/blockdev --setbsz 512 /dev/sda6
>>>> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
>>>> 4096
>>>
>>> I think each blockdev invocation is working on a *new* bdev object.
>>
>>
>> But the address of *new* bdev is the same?
>> I did printk, and they all returned the same address.
> 
> Then the block size value should be reset in one of the bd_set_size()
> calls in __blkdev_get().


Is the behaviour right that setting bd_block_size to the logical_block_size
every time when __blkdev_get()?

> 
>>> You'll get consistent results if somehow keep it referenced, for
>>
>>
>> But isn't it a bug? It seems that the setbsz has no effect?
> 
> Yeah, it does look like unexpected behavior to the end user..


And at least, the ioctl BLKBZSET seems useless.

Thanks
-Wanlong 

> 
> Thanks,
> Fengguang
> 


