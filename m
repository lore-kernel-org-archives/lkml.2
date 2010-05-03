Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0ECJTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:19:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63786 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0ECJTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J43hUUg4dV5KM9HhES7CvqXTcfodogQIldTZrLPvB8skFlXm0yhAiTL8V1MD/nXjlu
         rN3qawYAl69dUIfNRVBn9bMy9YKF+HMii+kn7MjT8OTiBZisx1y47QYzeiYVLgHXfA08
         DO+tvKF1NkOgsUUzgxPVMamg6bE4C4pi5MHiA=
Message-ID: <4BDE9504.8030401@suse.cz>
Date: Mon, 03 May 2010 11:19:00 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.6 Thunderbird/3.1b1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Changli Gao <xiaosuo@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <viro@zeniv.linux.org.uk>	 <1272818776-7729-1-git-send-email-xiaosuo@gmail.com>	 <4BDDB6E9.4060703@redhat.com>	 <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp>	 <4BDE67DA.4080004@redhat.com>	 <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com>	 <4BDE7E66.8030509@redhat.com>	 <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com>	 <4BDE8E24.5050200@redhat.com> <1272878032.2226.27.camel@edumazet-laptop>
In-Reply-To: <1272878032.2226.27.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 11:13 AM, Eric Dumazet wrote:
> /*
>  * Warning: if size is not a power of two, kmalloc() might
>  * waste memory because of its requirements.
>  */
> void *kvmalloc(size_t size)
> {
> 	void *ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);

This is kind of waste of high-order pages, isn't it? Wouldn't it be
better to have a watermark where we skip kmalloc completely?

> 
> 	if (ptr)
> 		return ptr;
> 	return vmalloc(size);
> }



-- 
js
suse labs
