Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab2CTOD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:03:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40956 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759985Ab2CTOD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <op.wbgvn00x3l0zgt@mpn-glaptop>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
	<1332238884-6237-2-git-send-email-laijs@cn.fujitsu.com>
	<op.wbgvn00x3l0zgt@mpn-glaptop>
Date: Tue, 20 Mar 2012 16:03:24 +0200
Message-ID: <CACVxJT_UVRjkSK+kieYVpO4R+D-4S2bXaoK-apxMkuFAYsgi_A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] kenrel.h: add ALIGN_OF_LAST_BIT()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 2:32 PM, Michal Nazarewicz <mina86@mina86.com> wrote:
> On Tue, 20 Mar 2012 11:21:19 +0100, Lai Jiangshan <laijs@cn.fujitsu.com>
> wrote:
>
>> Get the biggest 2**y that x % (2**y) == 0 for the align value.

>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -44,6 +44,8 @@
>>  #define PTR_ALIGN(p, a)                ((typeof(p))ALIGN((unsigned
>> long)(p), (a)))
>>  #define IS_ALIGNED(x, a)               (((x) & ((typeof(x))(a) - 1)) ==
>> 0)
>> +#define ALIGN_OF_LAST_BIT(x)   ((((x)^((x) - 1))>>1) + 1)
>
>
> Wouldn't ALIGNMENT() be less confusing? After all, that's what this macro is
> calculating, right? Alignment of given address.

Bits do not have alignment because they aren't directly addressable.
Can you hardcode this sequence with comment, because it looks too
special for macro.
