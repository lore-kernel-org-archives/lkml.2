Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab0IHM5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:57:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49737 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758699Ab0IHM53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:57:29 -0400
Message-ID: <4C878823.60709@cn.fujitsu.com>
Date: Wed, 08 Sep 2010 20:57:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and   
   functions
References: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>
In-Reply-To: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 14:19:25 +0200 (cest), Andi Kleen wrote:
>
>> According to the data, the length of the most copies is>=128.
>
> Thanks for the data. Large is easier to optimize than small, that's good.
>
> Could you also measure how many memsets need the backwards copy?
> (should be easy to add)

I think memset doesn't need the backwards copy.
The reason why memmove needs the backward copy is because the forward copy may
cover the data which will be used later if the dest string intersect with the
src string. But memset needn't worry about this problem.

Thanks!
Miao  

>
> If the number is small that needs backwards then the easiest fix
> would be to simply call the normal memcpy in the forward case.
>
> That is for backward could also use a string instruction copy
> of course, just have to set the direction flag.
>
> That would be a very small code change.
>
> -Andi
>
>
>
>

