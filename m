Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1EOIih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:38:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1EOIie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:38:34 -0400
Message-ID: <4DCF9105.4020000@redhat.com>
Date: Sun, 15 May 2011 11:38:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/7] KVM: MMU: optimize pte write path if don't have protected
 sp
References: <4DCEF5B1.3050706@cn.fujitsu.com> <4DCF8CBC.1040602@redhat.com> <4DCF8FC6.8050600@cn.fujitsu.com>
In-Reply-To: <4DCF8FC6.8050600@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2011 11:33 AM, Xiao Guangrong wrote:
> >
> >  These atomic ops are always called from within the spinlock, so we don't need an atomic_t here.
> >
> >  Sorry, I should have noticed this on the first version.
>
> We read indirect_shadow_pages atomically on pte write path, that is allowed out of mmu_lock

Reading is fine:

   #define atomic_read(v)    (*(volatile int *)&(v)->counter)

-- 
error compiling committee.c: too many arguments to function

