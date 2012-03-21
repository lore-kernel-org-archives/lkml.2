Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab2CUBdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:33:03 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:33229 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133Ab2CUBdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:33:00 -0400
Message-ID: <4F692FF3.6090305@mprc.pku.edu.cn>
Date: Wed, 21 Mar 2012 09:33:39 +0800
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] Disintegrate asm/system.h for Unicore32 [based on ver
 #3, changed by gxt]
References: <1332212514-22071-1-git-send-email-gxt@mprc.pku.edu.cn> <7019.1332155925@redhat.com> <14078.1332236020@redhat.com>
In-Reply-To: <14078.1332236020@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 05:33 PM, David Howells wrote:
> Guan Xuetao<gxt@mprc.pku.edu.cn>  wrote:
>
>> Disintegrate asm/system.h for Unicore32. (Compilation successful)
>> The implementation details are not changed, but only splitted.
>> BTW, some codestyles are adjusted.
>>
>> Signed-off-by: David Howells<dhowells@redhat.com>
>> Signed-off-by: Guan Xuetao<gxt@mprc.pku.edu.cn>
> Aha!  Much better.  It mostly looks reasonable, apart from one thing.  See the
> attached patch, which I'll roll in if you're happy with it.
That's great. It's just what I want  to do.
> -extern void panic(const char *fmt, ...);
> +/*
> + * Generate a link failure on undefined symbol if the pointer points to a value
> + * of unsupported size.
> + */
> +extern void __xchg_bad_pointer(void)
A semicolon should be added at the end.
>   static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
>   		int size)
> @@ -31,8 +35,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
>   			: "memory", "cc");
>   		break;
>   	default:
> -		panic("xchg: bad data size: ptr 0x%p, size %d\n",
> -			ptr, size);
> +		__xchg_bad_pointer();
> +		break;
I think  the 'break' sentence is redundant.

Thanks and Regards,
Guan Xuetao
