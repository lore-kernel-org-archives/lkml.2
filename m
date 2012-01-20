Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2ATIYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:24:20 -0500
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:41657 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751187Ab2ATIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:24:16 -0500
MIME-Version: 1.0
In-Reply-To: <CALfB72A+A9UDieFtYOMLB9c+XHO8nt8Lr-2pkikaqM=0fJ4OAQ@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
 <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
 <CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
 <CAL1RGDX9P7tmGTkByEid17FrSFwdAW+4=mb9eUxc_uHvmFOeSg@mail.gmail.com>
 <CALfB72CAwzRe3u2+yQ15+coY9kNgFTZ_Be-b-+aMe6QvbZy-HA@mail.gmail.com>
 <CALfB72CLZMrS+gTR3=0QcGry4vA3wKmgbhjp9Lc06UZtVcxzZg@mail.gmail.com> <CALfB72A+A9UDieFtYOMLB9c+XHO8nt8Lr-2pkikaqM=0fJ4OAQ@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 20 Jan 2012 00:23:52 -0800
Message-ID: <CAL1RGDVWDsNhHywkmzaGWxZ5ERYatXVh4fGFC_tmOkkLt3Dg+w@mail.gmail.com>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
To: Albert Strasheim <fullung@gmail.com>
Cc: linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:57 AM, Albert Strasheim <fullung@gmail.com> wrote:
> Just checking up on this issue. Is there any further testing or
> information we can provide to help make a fix happen?

I'm not likely to be much help on VT-d issues, but maybe it
would be useful to dump all the values in the BUG_ON if its
going to trigger, ie just before

       BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1)
>> addr_width);

add

       if (addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1) >> addr_width)
           pr_err("VT-d BUG! addr_width %d < %d (iov_pfn 0x%lx
nr_pages %ld)\n", addr_width, BITS_PER_LONG, iov_pfn, nr_pages);

and report what that prints.

 - R.
