Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1APPgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:36:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1APPgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:36:10 -0500
Message-ID: <4D331054.4030206@redhat.com>
Date: Sun, 16 Jan 2011 17:35:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for HWPOISON
 page optionally
References: <1294908168.4596.58.camel@yhuang-dev>	 <4D2ED737.6050802@redhat.com> <1294969036.4596.67.camel@yhuang-dev>
In-Reply-To: <1294969036.4596.67.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 03:37 AM, Huang Ying wrote:
> On Thu, 2011-01-13 at 18:43 +0800, Avi Kivity wrote:
> >  On 01/13/2011 10:42 AM, Huang Ying wrote:
> >  >  Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> >  >  FOLL_HWPOISON is specified.  With this patch, the interested callers
> >  >  can distinguish HWPOISON page from general FAULT page, while other
> >  >  callers will still get -EFAULT for pages, so the user space interface
> >  >  need not to be changed.
> >  >
> >  >  get_user_pages_hwpoison is added as a variant of get_user_pages that
> >  >  can return -EHWPOISON for HWPOISON page.
> >  >
> >  >  This feature is needed by KVM, where UCR MCE should be relayed to
> >  >  guest for HWPOISON page, while instruction emulation and MMIO will be
> >  >  tried for general FAULT page.
> >  >
> >  >  The idea comes from Andrew Morton.
> >  >
> >  >  Signed-off-by: Huang Ying<ying.huang@intel.com>
> >  >  Cc: Andrew Morton<akpm@linux-foundation.org>
> >  >
> >  >  +#ifdef CONFIG_MEMORY_FAILURE
> >  >  +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> >  >  +			    unsigned long start, int nr_pages, int write,
> >  >  +			    int force, struct page **pages,
> >  >  +			    struct vm_area_struct **vmas);
> >  >  +#else
> >
> >  Since we'd also like to add get_user_pages_noio(), perhaps adding a
> >  flags field to get_user_pages() is better.
>
> Or export __get_user_pages()?

That's better, yes.

-- 
error compiling committee.c: too many arguments to function

