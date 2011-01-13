Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab1AMKnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:43:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421Ab1AMKnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:43:22 -0500
Message-ID: <4D2ED737.6050802@redhat.com>
Date: Thu, 13 Jan 2011 12:43:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for HWPOISON
 page optionally
References: <1294908168.4596.58.camel@yhuang-dev>
In-Reply-To: <1294908168.4596.58.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 10:42 AM, Huang Ying wrote:
> Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> FOLL_HWPOISON is specified.  With this patch, the interested callers
> can distinguish HWPOISON page from general FAULT page, while other
> callers will still get -EFAULT for pages, so the user space interface
> need not to be changed.
>
> get_user_pages_hwpoison is added as a variant of get_user_pages that
> can return -EHWPOISON for HWPOISON page.
>
> This feature is needed by KVM, where UCR MCE should be relayed to
> guest for HWPOISON page, while instruction emulation and MMIO will be
> tried for general FAULT page.
>
> The idea comes from Andrew Morton.
>
> Signed-off-by: Huang Ying<ying.huang@intel.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
>
> +#ifdef CONFIG_MEMORY_FAILURE
> +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> +			    unsigned long start, int nr_pages, int write,
> +			    int force, struct page **pages,
> +			    struct vm_area_struct **vmas);
> +#else

Since we'd also like to add get_user_pages_noio(), perhaps adding a 
flags field to get_user_pages() is better.

-- 
error compiling committee.c: too many arguments to function

