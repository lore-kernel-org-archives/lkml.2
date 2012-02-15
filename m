Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2BOTeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:34:17 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:45081 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751251Ab2BOTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:34:16 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HK3fdK4VM1kT1NgoO4CSN8poYEUXbBPP1aan0vnZygVo4Wy
 C2S6kRlPHo0ga8PzN6NUzF36M34Vpk6yb.qs4V1wOTHkfLJRfFhrI74t9RyG
 bjTvJm.GRu05HcBYSq7DNJedks7R_a4O4vQW_BAgaKXE8hJEB0JXHb.j0kTX
 bYdhEsPWkmD0aouYg0ahEWm_PbR5aJM4CBiqWBsFdn7l11QG8zMr54RIlVGi
 8KPrYWRDvkvfsZObskXo7ROR_13gFqjC0_rPi8b0YPYQgxjdawaM8ZlkRoNS
 xO6Siuid15MxSooaV9GQGbUpBazKemLSbhWz8mCy3avFkBo4JeTylDzI77_y
 K4eNEMJrpyq4EX8RQNIOpbCSMHvqXyvnRZLdyTFyez8xQcUiZhWZk8eDlMn2
 CJClCFvzifVM6cGuLMnW1uhTfCBIOuACFAW41
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 15 Feb 2012 13:34:11 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Xi Wang <xi.wang@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
In-Reply-To: <07635976-4FC3-4E14-9B94-CE4D6446FD4E@gmail.com>
Message-ID: <alpine.DEB.2.00.1202151324060.28225@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda>
 <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
 <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org> <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com>
 <alpine.DEB.2.00.1202141605240.32407 @router.home> <07635976-4FC3-4E14-9B94-CE4D6446FD4E@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Xi Wang wrote:

> for overflow, one has to write:
>
>         size_t s = calculate_array_size(n, size);
>         if (s)
>                 p = kmalloc(s, ...);
>
> This "if" thing is just too verbose --- you need three lines to
> allocate an array.
>
> We could change calculate_array_size() to return ULONG_MAX or some
> large number with which kmalloc() would fail.  Then one would write:

Any allocation larger than MAX_ORDER << PAGE_SHIFT will fail since the
page allocator cannot serve larger contigous pages.


