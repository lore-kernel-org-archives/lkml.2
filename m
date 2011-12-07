Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1LGJmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:42:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1LGJmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:42:08 -0500
Message-ID: <4EDF34D6.2030200@redhat.com>
Date: Wed, 07 Dec 2011 17:41:42 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] highmem: fix missed kmap_atomic update in arch/arm/include/asm/highmem.h
References: <1323249719.27710.2.camel@phoenix> <20111207093514.GI4585@pengutronix.de>
In-Reply-To: <20111207093514.GI4585@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月07日 17:35, Uwe Kleine-König 写道:
> On Wed, Dec 07, 2011 at 05:21:59PM +0800, Axel Lin wrote:
>> commit 37bfbb "highmem: kill all __kmap_atomic()" missed the update to
>> arch/arm/include/asm/highmem.h.
>>
>> This patch fixes below build error:
>>    CC      init/main.o
>> In file included from include/linux/pagemap.h:10,
>>                   from include/linux/mempolicy.h:70,
>>                   from init/main.c:49:
>> include/linux/highmem.h: In function 'kmap_atomic_deprecated':
>> include/linux/highmem.h:127: error: implicit declaration of function 'kmap_atomic'
>> include/linux/highmem.h:127: warning: return makes pointer from integer without a cast
>> include/linux/highmem.h: In function 'clear_highpage':
>> include/linux/highmem.h:218: warning: initialization makes pointer from integer without a cast
>> include/linux/highmem.h: In function 'zero_user_segments':
>> include/linux/highmem.h:227: warning: initialization makes pointer from integer without a cast
>> include/linux/highmem.h: In function 'copy_highpage':
>> include/linux/highmem.h:279: warning: assignment makes pointer from integer without a cast
>> include/linux/highmem.h:280: warning: assignment makes pointer from integer without a cast
>> make[1]: *** [init/main.o] Error 1
>> make: *** [init] Error 2
> Already reported and fixed, see
>
> 	http://thread.gmane.org/gmane.linux.kernel/1225278
>

Yeah, sorry for this.

I have squashed Stephen's patch into my tree. Thanks for your patch anyway, Axel!
