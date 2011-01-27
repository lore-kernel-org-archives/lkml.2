Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab1A0H3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:29:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:34861 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1A0H3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:29:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,385,1291622400"; 
   d="scan'208";a="651639760"
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <20110120155021.GA5996@amt.cnet>
References: <1294908168.4596.58.camel@yhuang-dev>
	 <4D2ED737.6050802@redhat.com> <1294969036.4596.67.camel@yhuang-dev>
	 <4D331054.4030206@redhat.com> <1295225259.10748.3.camel@yhuang-dev>
	 <20110120155021.GA5996@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 15:29:05 +0800
Message-ID: <1296113345.15213.87.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

On Thu, 2011-01-20 at 23:50 +0800, Marcelo Tosatti wrote:
> On Mon, Jan 17, 2011 at 08:47:39AM +0800, Huang Ying wrote:
> > Hi, Andrew,
> > 
> > On Sun, 2011-01-16 at 23:35 +0800, Avi Kivity wrote:
> > > On 01/14/2011 03:37 AM, Huang Ying wrote:
> > > > On Thu, 2011-01-13 at 18:43 +0800, Avi Kivity wrote:
> > > > >  On 01/13/2011 10:42 AM, Huang Ying wrote:
> > > > >  >  Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> > > > >  >  FOLL_HWPOISON is specified.  With this patch, the interested callers
> > > > >  >  can distinguish HWPOISON page from general FAULT page, while other
> > > > >  >  callers will still get -EFAULT for pages, so the user space interface
> > > > >  >  need not to be changed.
> > > > >  >
> > > > >  >  get_user_pages_hwpoison is added as a variant of get_user_pages that
> > > > >  >  can return -EHWPOISON for HWPOISON page.
> > > > >  >
> > > > >  >  This feature is needed by KVM, where UCR MCE should be relayed to
> > > > >  >  guest for HWPOISON page, while instruction emulation and MMIO will be
> > > > >  >  tried for general FAULT page.
> > > > >  >
> > > > >  >  The idea comes from Andrew Morton.
> > > > >  >
> > > > >  >  Signed-off-by: Huang Ying<ying.huang@intel.com>
> > > > >  >  Cc: Andrew Morton<akpm@linux-foundation.org>
> > > > >  >
> > > > >  >  +#ifdef CONFIG_MEMORY_FAILURE
> > > > >  >  +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> > > > >  >  +			    unsigned long start, int nr_pages, int write,
> > > > >  >  +			    int force, struct page **pages,
> > > > >  >  +			    struct vm_area_struct **vmas);
> > > > >  >  +#else
> > > > >
> > > > >  Since we'd also like to add get_user_pages_noio(), perhaps adding a
> > > > >  flags field to get_user_pages() is better.
> > > >
> > > > Or export __get_user_pages()?
> > > 
> > > That's better, yes.
> > 
> > Do you think it is a good idea to export __get_user_pages() instead of
> > adding get_user_pages_noio() and get_user_pages_hwpoison()?
> 
> Better Andrew and/or Linus should decide it.

We really need your comments about this.

Best Regards,
Huang Ying


