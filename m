Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1CACVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 21:21:55 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49110 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab1CACVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 21:21:53 -0500
Subject: Re: [PATCH] ksm: add vm_stat and meminfo entry to reflect pte
 mapping to ksm pages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: nai.xia@gmail.com
Cc: Izik Eidus <ieidus@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201102262256.31565.nai.xia@gmail.com>
References: <201102262256.31565.nai.xia@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 28 Feb 2011 18:21:48 -0800
Message-ID: <1298946108.9138.1173.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-26 at 22:56 +0800, Nai Xia wrote
> @@ -904,6 +905,10 @@ static int try_to_merge_one_page(struct vm_area_struct 
> *vma,
>                          */
>                         set_page_stable_node(page, NULL);
>                         mark_page_accessed(page);
> +                       if (mapcount)
> +                               add_zone_page_state(page_zone(page),
> +                                                   NR_KSM_PAGES_SHARING,
> +                                                   mapcount);
>                         err = 0;
>                 } else if (pages_identical(page, kpage))
>                         err = replace_page(vma, page, kpage, orig_pte); 

If you're going to store this per-zone, does it make sense to have it
show up in /proc/zoneinfo?  meminfo's also getting pretty porky these
days, so I almost wonder if it should stay in zoneinfo only.

-- Dave

