Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0ECJXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:23:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:17348 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0ECJXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p32W2Vcff358Stt62GGyTeeg/z9bcrFmgmz3Dj1oi7N2PbFbOb93VM+/E3eHtDUVhU
         s4hAHutEe97ub3NALWrANguC/K7A6iLA8KT0Q5STtBzAq1J/JyUI6TSsUZq6TdWC99Yj
         wRNQGpgWszX81mbKnFbLoTQIFLEfsvMwpCWGk=
Message-ID: <4BDE95F2.1020506@suse.cz>
Date: Mon, 03 May 2010 11:22:58 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.6 Thunderbird/3.1b1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Changli Gao <xiaosuo@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com> 	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp> 	<4BDE67DA.4080004@redhat.com> <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com> 	<4BDE7E66.8030509@redhat.com> <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com> <4BDE8E24.5050200@redhat.com> <4BDE914C.6080504@suse.cz> <4BDE94C8.9000108@redhat.com>
In-Reply-To: <4BDE94C8.9000108@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 11:18 AM, Avi Kivity wrote:
> On 05/03/2010 12:03 PM, Jiri Slaby wrote:
>>>> Because vmalloc is used to allocate virtually contiguous memory. v in
>>>> vmalloc means virtually.
>>>>
>>>>
>>>>        
>>> A kmalloc()ed page is virtually contiguous, satisfying your requirement.
>>>      
>> But it won't work well for vmalloc_to_{page,pfn} and similar.
> 
> Modify vmalloc_to_{page,pfn} accordingly.

When you get a slub in the middle of page, how?

>> Some code
>> may expect vmalloc result to be in the vmalloc area and page-aligned
>> (both in position and size).
>>    
> 
> Both would be a bug IMO.  vmalloc() follows kmalloc() and malloc() which
> only guarantee natural alignment.

Nope, from what I understand, vmalloc aligns (uses page allocator). Even
for purposes of vmalloc_to_*.

regards,
-- 
js
suse labs
