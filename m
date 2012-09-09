Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2IIPcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:32:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59754 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2IIPcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <1347202600.5876.7.camel@sbsiddha-ivb>
References: <1340959739.2936.28.camel@lappy> <CA+1xoqdgKV_sEWvUbuxagL9JEc39ZFa6X9-acP7j-M7wvW6qbQ@mail.gmail.com>
 <CA+55aFzJCLxVP+WYJM-gq=aXx5gmdgwC7=_Gr2Tooj8q+Dz4dw@mail.gmail.com>
 <1347057778.26695.68.camel@sbsiddha-desk.sc.intel.com> <CA+55aFwW9Q+DM2gZy7r3JQJbrbMNR6sN+jewc2CY0i1wD_X=Tw@mail.gmail.com>
 <1347062045.26695.82.camel@sbsiddha-desk.sc.intel.com> <CA+55aFzeKcV5hROLJE31dNi3SEs+s6o0LL=96Kh8QGHPx=aZnA@mail.gmail.com>
 <1347202600.5876.7.camel@sbsiddha-ivb>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Sep 2012 08:31:57 -0700
X-Google-Sender-Auth: WYlA3RVICaPUyn3uNwR9fHrXpBo
Message-ID: <CA+55aFwej93o7aLe_xwV5CGuT0BDyAz54cyWm6Xe3wj-hCT3PA@mail.gmail.com>
Subject: Re: mtd: kernel BUG at arch/x86/mm/pat.c:279!
To: suresh.b.siddha@intel.com
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 7:56 AM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
> yes but that is not a valid range I think because of the supported
> physical address bit limits of the processor and also the max
> architecture limit of 52 address bits.

But how could the caller possibly know that? None of those internal
PAT limits are exposed anywhere.

So doing the BUG_ON() is wrong. I'd suggest changing it to an EINVAL.

In fact, BUG_ON() is *always* wrong, unless it's a "my internal data
structures are so messed up that I cannot continue".

                Linus
