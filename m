Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2JJNxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:53:37 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47567 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2JJNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:53:34 -0400
Date: Wed, 10 Oct 2012 09:41:45 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86, mm: Don't clear page table if next range is ram
Message-ID: <20121010134139.GA4005@phenom.dumpdata.com>
References: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
 <1349509469-11475-1-git-send-email-yinghai@kernel.org>
 <1349509469-11475-3-git-send-email-yinghai@kernel.org>
 <20121009154611.GC7639@phenom.dumpdata.com>
 <CAE9FiQV2r6GsuxkceBrR7Tpv40SwQku0Z+ZtMBbNKZ9BJgvUXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV2r6GsuxkceBrR7Tpv40SwQku0Z+ZtMBbNKZ9BJgvUXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 06:00:12PM -0700, Yinghai Lu wrote:
> On Tue, Oct 9, 2012 at 8:46 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> >> +                         !e820_any_mapped(addr & PAGE_MASK, next, 0))
> >
> > What is the 0 parameter for?
> 
> any type

OK, which means that it either should have a #define for it, or at least
a comment, like:

0 /* any type */

as this would make it clear at first glance what it is - without having
to dive in e820_any_mapped function to determine that.

> 
> if type != 0, the will only check entries with same type.
> 
> int
> e820_any_mapped(u64 start, u64 end, unsigned type)
> {
>         int i;
> 
>         for (i = 0; i < e820.nr_map; i++) {
>                 struct e820entry *ei = &e820.map[i];
> 
>                 if (type && ei->type != type)
>                         continue;
>                 if (ei->addr >= end || ei->addr + ei->size <= start)
>                         continue;
>                 return 1;
>         }
>         return 0;
> }
> 
