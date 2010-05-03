Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0ECHwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 03:52:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34016 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0ECHws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 03:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=q7Oet+hnJ6P6cSO/0FnZiuY9pwwdtMCTsjv1lF4lnClVLuc1VNebChX26RbYz1wWSM
         +a4owdJrpP2V3UoCa1IARqSPpDbkYZm0Z+IOY/V2YiGzdWdpDTSyEjqBzq2AzlyPNQGk
         Xzs4z6Kbm5wd2n5lpLjo9kZ7g+Cptiklx1QQo=
MIME-Version: 1.0
In-Reply-To: <4BDE7E66.8030509@redhat.com>
References: <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com> 
	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp> 
	<4BDE67DA.4080004@redhat.com> <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com> 
	<4BDE7E66.8030509@redhat.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Mon, 3 May 2010 15:52:27 +0800
Message-ID: <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com>
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
To: Avi Kivity <avi@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, jslaby@suse.cz,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 3:42 PM, Avi Kivity <avi@redhat.com> wrote:
> On 05/03/2010 10:05 AM, Changli Gao wrote:
>>
>> On Mon, May 3, 2010 at 2:06 PM, Avi Kivity<avi@redhat.com>  wrote:
>>
>>>
>>> My point is, vmalloc() and vfree should do this, not their callers:
>>>
>>> vmalloc(size):
>>>    if (size<= PAGE_SIZE)
>>>        return kmalloc(size, GFP_KERNEL);
>>>    ...
>>>
>>> vfree(p):
>>>    if (!is_vmalloc_addr(p) {
>>>        kfree(p);
>>>        return;
>>>    }
>>>    ...
>>>
>>
>> I think we should not change vmalloc/vfree, and you can invent new
>> memory APIs, such as malloc()/free().
>>
>
> Why?
>

Because vmalloc is used to allocate virtually contiguous memory. v in
vmalloc means virtually.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
