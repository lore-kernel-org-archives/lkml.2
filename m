Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803Ab2CSAbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:31:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50088 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab2CSAbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:31:20 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F667DF1.3090109@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 09:29:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: seq_put_decimal_ull() et al
References: <CACVxJT_UWzpVo1Jfbf5Z2A-s16QjEv05MiNSY_EGihKTPuMyxg@mail.gmail.com> <20120314093156.2bc3d3c5.kamezawa.hiroyu@jp.fujitsu.com> <20120314110844.d1654724.kamezawa.hiroyu@jp.fujitsu.com> <CACVxJT9mkX+7+hFrbt2rNCjUH9Y=t2AtGaXqcGfMh6x5WwMjmw@mail.gmail.com>
In-Reply-To: <CACVxJT9mkX+7+hFrbt2rNCjUH9Y=t2AtGaXqcGfMh6x5WwMjmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/16 20:16), Alexey Dobriyan wrote:

> On Wed, Mar 14, 2012 at 5:08 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Wed, 14 Mar 2012 09:31:56 +0900
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>>> On Tue, 13 Mar 2012 15:35:54 +0200
>>> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>>
>>>>> Subject:    + procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch added to -mm tree
>>>>
>>>> I think the fix is to create proper binary interface for exporting
>>>> interrupt counts.
>>>> Programs can parse raw data equally well if programming language is
>>>> even minimally reasonable
>>>> (POSIX shell may not qualify, though).
>>>
>>> Ok, please try with all tool-chain updates.
>>> procps, top, sar, and more ?
>>>
> 
> Well, why not?
> We can tune print code or we can create maximally fast interface and forget.
> 

Do you have an idea where to place it ? 
/proc/stat_binary ?
/proc/binary/stat ?

Hm, to parse /proc/stat binary format, the user has to know the format of the
kernel version.

Do we show a format file as
/proc/binary/stat_format and show
# cat /proc/binary/stat_format
  =IHHHIHIQQQIHQQ...

as python's pack/unpack ? or
export the format via /usr/include/linux/proc_format.h ? as a structure ?

any better idea ?

Thanks,
-Kame







