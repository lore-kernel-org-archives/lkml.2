Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2CJIih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 03:38:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39692 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2CJIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 03:38:36 -0500
Message-ID: <4F5B1305.4080306@gmail.com>
Date: Sat, 10 Mar 2012 16:38:29 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux@arm.linux.org.uk,
        vgoyal@redhat.com
Subject: Re: [PATCH v2] kdump x86: fix total mem size calculation for reservation
References: <20120309083009.GA14067@darkstar.nay.redhat.com> <4F5ACA2D.5000000@gmail.com> <20120310045632.GA4214@darkstar.redhat.com>
In-Reply-To: <20120310045632.GA4214@darkstar.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 12:56 PM, Dave Young wrote:
> crashkernel reservation need know the total memory size. Current get_total_mem
> simply use max_pfn - min_low_pfn. It is wrong because it will including
> memory holes in the middle.
>
> Especially for kvm guest with memory>  0xe0000000, there's below in qemu code:
> qemu split memory as below:
>      if (ram_size>= 0xe0000000 ) {
>          above_4g_mem_size = ram_size - 0xe0000000;
>          below_4g_mem_size = 0xe0000000;
>      } else {
>          below_4g_mem_size = ram_size;
>      }
> So for 4G mem guest, seabios will insert a 512M usable region beyond of 4G.
> Thus in above case max_pfn - min_low_pfn will be more than original memsize.
>
> Fixing this issue by using memblock_phys_mem_size() to get the total memsize.
>
> [v1 ->  v2]: refresh the patch based on latest linus tree
>

Looks good to my eyes,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Can you post the result of crashkernel after this patch to convince people?

Thanks.
