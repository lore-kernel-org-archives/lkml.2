Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab1DOOvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:51:22 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:38176 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756123Ab1DOOvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:51:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: UsrH9hEVM1n.21PTgSHD0CnVktC0g4nOpHHCqoz50vvPG7F
 9.ZU7X_MI3g2mrN6qcJ02.ZExRy7lWmuPQEAVuBEH2i7jlOkbOvuqEoqnrYr
 rYqPNDSu8h2PRJOsogal1JqtFnjvwDU3S7u_FxgzVe57WgEQ6vhVeP5CHi8k
 MGPGBgi2HiJpmyDDj5mrns3gH1ln.vnz44999p.7b57T9.yehU7sGFn4ODlH
 T8kN91AkOBIT.fQm0BeWjRPk_OjtaAdWug3Kq3oIyGGdtFj.KJAoNN3wr.M6
 InYUAZMz3AouR2FWjywT44vhQ_.Aof.t9Z30z6y.tEoBW15Fp
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 15 Apr 2011 09:51:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: make read-only accessors take const parameters
In-Reply-To: <1302861377-8048-2-git-send-email-ext-phil.2.carmody@nokia.com>
Message-ID: <alpine.DEB.2.00.1104150949210.5863@router.home>
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com> <1302861377-8048-2-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Phil Carmody wrote:

> +++ b/include/linux/mm.h
> @@ -353,9 +353,16 @@ static inline struct page *compound_head(struct page *page)
>  	return page;
>  }
>
> -static inline int page_count(struct page *page)
> +static inline const struct page *compound_head_ro(const struct page *page)
>  {
> -	return atomic_read(&compound_head(page)->_count);
> +	if (unlikely(PageTail(page)))
> +		return page->first_page;
> +	return page;
> +}

Can you make compound_head take a const pointer too to avoid this?

