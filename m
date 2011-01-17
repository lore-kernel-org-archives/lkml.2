Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab1AQAro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 19:47:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:28955 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab1AQArm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 19:47:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,331,1291622400"; 
   d="scan'208";a="697445976"
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>
In-Reply-To: <4D331054.4030206@redhat.com>
References: <1294908168.4596.58.camel@yhuang-dev>
	 <4D2ED737.6050802@redhat.com> <1294969036.4596.67.camel@yhuang-dev>
	 <4D331054.4030206@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 08:47:39 +0800
Message-ID: <1295225259.10748.3.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

On Sun, 2011-01-16 at 23:35 +0800, Avi Kivity wrote:
> On 01/14/2011 03:37 AM, Huang Ying wrote:
> > On Thu, 2011-01-13 at 18:43 +0800, Avi Kivity wrote:
> > >  On 01/13/2011 10:42 AM, Huang Ying wrote:
> > >  >  Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> > >  >  FOLL_HWPOISON is specified.  With this patch, the interested callers
> > >  >  can distinguish HWPOISON page from general FAULT page, while other
> > >  >  callers will still get -EFAULT for pages, so the user space interface
> > >  >  need not to be changed.
> > >  >
> > >  >  get_user_pages_hwpoison is added as a variant of get_user_pages that
> > >  >  can return -EHWPOISON for HWPOISON page.
> > >  >
> > >  >  This feature is needed by KVM, where UCR MCE should be relayed to
> > >  >  guest for HWPOISON page, while instruction emulation and MMIO will be
> > >  >  tried for general FAULT page.
> > >  >
> > >  >  The idea comes from Andrew Morton.
> > >  >
> > >  >  Signed-off-by: Huang Ying<ying.huang@intel.com>
> > >  >  Cc: Andrew Morton<akpm@linux-foundation.org>
> > >  >
> > >  >  +#ifdef CONFIG_MEMORY_FAILURE
> > >  >  +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> > >  >  +			    unsigned long start, int nr_pages, int write,
> > >  >  +			    int force, struct page **pages,
> > >  >  +			    struct vm_area_struct **vmas);
> > >  >  +#else
> > >
> > >  Since we'd also like to add get_user_pages_noio(), perhaps adding a
> > >  flags field to get_user_pages() is better.
> >
> > Or export __get_user_pages()?
> 
> That's better, yes.

Do you think it is a good idea to export __get_user_pages() instead of
adding get_user_pages_noio() and get_user_pages_hwpoison()?

Best Regards,
Huang Ying


