Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0IPHQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:16:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51820 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab0IPHQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:16:26 -0400
Message-ID: <4C91C44F.40700@cn.fujitsu.com>
Date: Thu, 16 Sep 2010 15:16:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
In-Reply-To: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 08:48:25 +0200 (cest), Andi Kleen wrote:
>> When the dest and the src do overlap and the memory area is large, memmove
>> of
>> x86_64 is very inefficient, and it led to bad performance, such as btrfs's
>> file
>> deletion performance. This patch improved the performance of memmove on
>> x86_64
>> by using __memcpy_bwd() instead of byte copy when doing large memory area
>> copy
>> (len>  64).
>
>
> I still don't understand why you don't simply use a backwards
> string copy (with std) ? That should be much simpler and
> hopefully be as optimized for kernel copies on recent CPUs.

But according to the comment of memcpy, some CPUs don't support "REP" instruction,
so I think we must implement a backwards string copy by other method for those CPUs,
But that implement is complex, so I write it as a function -- __memcpy_bwd().

Thanks!
Miao
