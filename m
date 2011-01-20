Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1ATWZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:25:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab1ATWZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:25:11 -0500
Date: Thu, 20 Jan 2011 13:50:21 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
Message-ID: <20110120155021.GA5996@amt.cnet>
References: <1294908168.4596.58.camel@yhuang-dev>
 <4D2ED737.6050802@redhat.com>
 <1294969036.4596.67.camel@yhuang-dev>
 <4D331054.4030206@redhat.com>
 <1295225259.10748.3.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295225259.10748.3.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 08:47:39AM +0800, Huang Ying wrote:
> Hi, Andrew,
> 
> On Sun, 2011-01-16 at 23:35 +0800, Avi Kivity wrote:
> > On 01/14/2011 03:37 AM, Huang Ying wrote:
> > > On Thu, 2011-01-13 at 18:43 +0800, Avi Kivity wrote:
> > > >  On 01/13/2011 10:42 AM, Huang Ying wrote:
> > > >  >  Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> > > >  >  FOLL_HWPOISON is specified.  With this patch, the interested callers
> > > >  >  can distinguish HWPOISON page from general FAULT page, while other
> > > >  >  callers will still get -EFAULT for pages, so the user space interface
> > > >  >  need not to be changed.
> > > >  >
> > > >  >  get_user_pages_hwpoison is added as a variant of get_user_pages that
> > > >  >  can return -EHWPOISON for HWPOISON page.
> > > >  >
> > > >  >  This feature is needed by KVM, where UCR MCE should be relayed to
> > > >  >  guest for HWPOISON page, while instruction emulation and MMIO will be
> > > >  >  tried for general FAULT page.
> > > >  >
> > > >  >  The idea comes from Andrew Morton.
> > > >  >
> > > >  >  Signed-off-by: Huang Ying<ying.huang@intel.com>
> > > >  >  Cc: Andrew Morton<akpm@linux-foundation.org>
> > > >  >
> > > >  >  +#ifdef CONFIG_MEMORY_FAILURE
> > > >  >  +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> > > >  >  +			    unsigned long start, int nr_pages, int write,
> > > >  >  +			    int force, struct page **pages,
> > > >  >  +			    struct vm_area_struct **vmas);
> > > >  >  +#else
> > > >
> > > >  Since we'd also like to add get_user_pages_noio(), perhaps adding a
> > > >  flags field to get_user_pages() is better.
> > >
> > > Or export __get_user_pages()?
> > 
> > That's better, yes.
> 
> Do you think it is a good idea to export __get_user_pages() instead of
> adding get_user_pages_noio() and get_user_pages_hwpoison()?

Better Andrew and/or Linus should decide it.

