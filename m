Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0ECHnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 03:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0ECHng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 03:43:36 -0400
Message-ID: <4BDE7E66.8030509@redhat.com>
Date: Mon, 03 May 2010 10:42:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, jslaby@suse.cz,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com> 	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp> 	<4BDE67DA.4080004@redhat.com> <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com>
In-Reply-To: <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 10:05 AM, Changli Gao wrote:
> On Mon, May 3, 2010 at 2:06 PM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> My point is, vmalloc() and vfree should do this, not their callers:
>>
>> vmalloc(size):
>>     if (size<= PAGE_SIZE)
>>         return kmalloc(size, GFP_KERNEL);
>>     ...
>>
>> vfree(p):
>>     if (!is_vmalloc_addr(p) {
>>         kfree(p);
>>         return;
>>     }
>>     ...
>>      
> I think we should not change vmalloc/vfree, and you can invent new
> memory APIs, such as malloc()/free().
>    

Why?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

