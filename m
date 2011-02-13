Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1BMPGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:06:19 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:40410 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753989Ab1BMPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:06:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ayTgMxS8CwwOId301eUF1oOmxdl4Bt8PUcQbL8zyiQfWCIFRkrME6rIAoUiY0esh3IGHkx4IslpZdcHUVOeTcrkABOQzxu8jnVYQQpGn/o9a23acMwvbP8403hYSYau2;
Message-ID: <4D57F357.6060708@tao.ma>
Date: Sun, 13 Feb 2011 23:05:59 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma> <4D57E67E.1030707@redhat.com>
In-Reply-To: <4D57E67E.1030707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.245.231.214 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 10:11 PM, Milan Broz wrote:
> On 02/13/2011 11:58 AM, Tao Ma wrote:
>    
>> From: Tao Ma<boyu.mt@taobao.com>
>>
>> In 75f1dc0, we check bdev_read_only() from blkdev_get().
>> But the loop_clr_fd doesn't clear the read only flag.
>> What cause a error if we changing a loop device from
>> read only to writable.
>>      
> No, sorry, this is not proper/complete fix. It fixes it for loop
> (and even not completely - you are missing some error
> paths and ignoring autoclear mode where you have bdev NULL.)
> (And yes, I tried the same as workaround.)
>    
aha, sorry, I don't know you are more familiar with loop than me. ;)
I just did a quick test and sent the patch. So could you please tell me
a little more about how we use autoclear mode? I just googled but can't
find some helpful information. I will try to update my patch with a V2 when
I get familiar with the whole stuff.
> And it will not help for DM case (and possibly others).
>    
Actually I don't think it is Tejun's patch that causes the bug. What his 
patch do
is to expose some bugs that already exist.  Say loop, it sets ro when it 
get read
only flags, but doesn't clear it when it is detached. It should be 
loop's problem,
not blkdev's. As for the DM case, I guess it should also be related to 
DM part.

Regards,
Tao
