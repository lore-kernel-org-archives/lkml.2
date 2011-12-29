Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab1L2E3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 23:29:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab1L2E3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 23:29:47 -0500
Message-ID: <4EFBEC7C.4060902@cn.fujitsu.com>
Date: Thu, 29 Dec 2011 12:28:44 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug in BLKBSZSET/GET ioctl ?
References: <4EFBE3D1.5030608@cn.fujitsu.com> <20111229042010.GA22132@localhost>
In-Reply-To: <20111229042010.GA22132@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 12:28:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 12:28:55,
	Serialize complete at 2011-12-29 12:28:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 12:20 PM, Wu Fengguang wrote:

> On Thu, Dec 29, 2011 at 11:51:45AM +0800, Wanlong Gao wrote:
>> Hi all:
>>
>> This is first reported to *libguestfs*: https://bugzilla.redhat.com/show_bug.cgi?id=624335
>>
>> Then, I looked into upstream util-linux and it seems nothing wrong. I'm not convinced that it's a kernel bug.
>>
>> produce:
>>
>> ---
>> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
>> 4096
>> # ./util-linux/disk-utils/blockdev --setbsz 2048 /dev/sda6
>> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
>> 4096
>> # ./util-linux/disk-utils/blockdev --setbsz 512 /dev/sda6
>> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
>> 4096
> 
> I think each blockdev invocation is working on a *new* bdev object.


But the address of *new* bdev is the same?
I did printk, and they all returned the same address.

> You'll get consistent results if somehow keep it referenced, for


But isn't it a bug? It seems that the setbsz has no effect?

Thanks,
-Wanlong

> example, run a background copy task:
> 
> # cp /dev/sda6 /dev/null &
> 
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> # ./util-linux/disk-utils/blockdev --setbsz 512 /dev/sda6
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> 
> Thanks,
> Fengguang
> 


