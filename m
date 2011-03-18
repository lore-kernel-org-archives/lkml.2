Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1CRGyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 02:54:43 -0400
Received: from mailgate2.nju.edu.cn ([202.119.32.2]:42188 "EHLO
	mail.nju.edu.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752742Ab1CRGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 02:54:35 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 02:54:35 EDT
X-Spam-Flag: NO
X-Spam-Score: -9.977
From: "xianai@nju.edu.cn" <xianai@nju.edu.cn>
Reply-To: xianai@nju.edu.cn
Organization: NJU
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] ksm: add vm_stat and meminfo entry to reflect pte mapping to ksm pages
Date: Fri, 18 Mar 2011 14:44:27 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.36.4; KDE/4.6.1; i686; ; )
Cc: Izik Eidus <ieidus@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <201102262256.31565.nai.xia@gmail.com> <1298946108.9138.1173.camel@nimitz>
In-Reply-To: <1298946108.9138.1173.camel@nimitz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181444.27725.xianai@nju.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>On Tuesday 01 March 2011, at 10:21:48, <Dave Hansen <dave@linux.vnet.ibm.com>> wrote
> On Sat, 2011-02-26 at 22:56 +0800, Nai Xia wrote
> > @@ -904,6 +905,10 @@ static int try_to_merge_one_page(struct vm_area_struct 
> > *vma,
> >                          */
> >                         set_page_stable_node(page, NULL);
> >                         mark_page_accessed(page);
> > +                       if (mapcount)
> > +                               add_zone_page_state(page_zone(page),
> > +                                                   NR_KSM_PAGES_SHARING,
> > +                                                   mapcount);
> >                         err = 0;
> >                 } else if (pages_identical(page, kpage))
> >                         err = replace_page(vma, page, kpage, orig_pte); 
> 
> If you're going to store this per-zone, does it make sense to have it
> show up in /proc/zoneinfo?  meminfo's also getting pretty porky these
> days, so I almost wonder if it should stay in zoneinfo only.

Yes, thanks for pointing out, I will fix it soon. And sorry for the late 
response,there was a bug in my mail client which prevents this mail from being 
filtered out.

Nai

> 
> -- Dave
> 
> 
