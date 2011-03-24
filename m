Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab1CXIds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:33:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46323 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681Ab1CXIdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:33:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Mar 2011 17:26:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Justin TerAvest <teravest@google.com>
Cc: vgoyal@redhat.com, jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com,
        ryov@valinux.co.jp, taka@valinux.co.jp, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] block,fs,mm: IO cgroup tracking for buffered
 write
Message-Id: <20110324172630.e71791a9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTinnDTa8_rVorBsacm-uHqJSA=JbYM9RKXswd8Sr@mail.gmail.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
	<1300835335-2777-3-git-send-email-teravest@google.com>
	<20110323135241.4ada8334.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTinnDTa8_rVorBsacm-uHqJSA=JbYM9RKXswd8Sr@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 10:21:01 -0700
Justin TerAvest <teravest@google.com> wrote:

> On Tue, Mar 22, 2011 at 9:52 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 22 Mar 2011 16:08:49 -0700
> > Justin TerAvest <teravest@google.com> wrote:
> >
> >> +static inline void page_cgroup_set_blkio_id(struct page_cgroup *pc,
> >> +                             unsigned long id)
> >> +{
> >> +     unsigned long old, new, prev;
> >> +
> >> +     /* pc->flags isn't lock protected, so we must cmpxchg. */
> >> +     WARN_ON(id >= (1UL << PAGE_TRACKING_ID_BITS));
> >> +     do {
> >> +             new = old = pc->flags;
> >> +             new &= (1UL << PAGE_TRACKING_ID_SHIFT) - 1;
> >> +             new |= (unsigned long)(id << PAGE_TRACKING_ID_SHIFT);
> >> +             prev = cmpxchg(&pc->flags, old, new);
> >> +     } while (prev != old);
> >
> > How to support archs which doesn't have cmpxchg ?
> > At least, you need take care of compile error.
> 
> Hi Kame,
> 
> Is there really no generic cmpxchg()? I thought that was what
> include/asm-generic/cmpxchg-local.h was for.
> 

I'm not sure ;) But I myself tend to avoid to use cmpxchg which
cannot be used in CONFIG_SMP, sometimes.

Thanks,
-Kame



