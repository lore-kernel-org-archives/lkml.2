Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2LTLEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:04:07 -0500
Received: from forward17.mail.yandex.net ([95.108.253.142]:56487 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2LTLEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:04:00 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 06:04:00 EST
From: Roman Gushchin <klamm@yandex-team.ru>
To: Simon Jeons <simon.jeons@gmail.com>, Eric Wong <normalperson@yhbt.net>
Cc: xtu4 <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "di.zhang@intel.com" <di.zhang@intel.com>
In-Reply-To: <1355984435.1374.3.camel@kernel-VirtualBox>
References: <50C4B4E7.60601@intel.com> <50C6AB45.606@intel.com>
	 <20121216021508.GA3629@dcvr.yhbt.net> <1355984435.1374.3.camel@kernel-VirtualBox>
Subject: Re: resend--[PATCH]  improve read ahead in kernel
MIME-Version: 1.0
Message-Id: <1461356000918@webcorp1g.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 20 Dec 2012 14:55:18 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

20.12.2012, 10:21, "Simon Jeons" <simon.jeons@gmail.com>:
> On Sun, 2012-12-16 at 02:15 +0000, Eric Wong wrote:
>
>> šxtu4 <xiaobing.tu@intel.com> wrote:
>>> šresend it, due to format error
>>>
>>> šSubject: [PATCH] when system in low memory scenario, imaging there is a mp3
>>> ššplay, ora video play, we need to read mp3 or video file
>>> ššfrom memory to page cache,but when system lack of memory,
>>> ššpage cache of mp3 or video file will be reclaimed.once read
>>> ššin memory, then reclaimed, it will cause audio or video
>>> ššglitch,and it will increase the io operation at the same
>>> šštime.
>> šTo me, this basically describes how POSIX_FADV_NOREUSE should work.
>
> Hi Eric,
>
> But why fadvise POSIX_FADV_NOREUSE almost do nothing? Why not set some
> flag or other things for these use once data?

Because, it's not clear how should it work in some cases.
Do we expect one access? Should we track a page as accessed after any access (even if only one byte was read)?
What should we do with already-cached pages? etc.

IMHO, it will be better to introduce something like POSIX_FADV_DONTCACHE.
Corresponding pages can be added (ratated) to the tail of the inactive LRU after copying data in read() internals,
or after minor/major pagefault.

>
>> šI would like to have this ability via fadvise (and not CONFIG_).
>>
>> šAlso, I think your patch has too many #ifdefs to be accepted.
>>
>> š--
>> šTo unsubscribe, send a message with 'unsubscribe linux-mm' in
>> šthe body to majordomo@kvack.org. šFor more info on Linux MM,
>> šsee: http://www.linux-mm.org/ .
>> šDon't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org. šFor more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
