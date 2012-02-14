Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2BNQev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:34:51 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:44452 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754522Ab2BNQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:34:50 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: z6.24boVM1nMvim3RChcCPyo731IgbDPx9TKFNiokbEJqLD
 tH1LkE5N.sSIRHjHnw6bCZN7pPpBakITyxWwBa_cL4u1G1sSdK.qyKoovuiP
 ae.kHDprym7UwmlaTi5mtWsd3otLv7CEx_veE1RsrCsRV3jgusgnIrJYhSrO
 9.zlwHvnBE6BtkGFSqDNbzpOkqcX6vw5xPx1qiMmSe1aRjixG.qcGwZcnj8k
 9fVWbdSKojGaU96_W7GeEywKxHXZqzM1r3Hst5THRsICGhKKEqolqgC_LDGl
 ajxcym4PQHaRTgRBY7fhD8WAUOmtP4vxB2THt5RdoYagUZ3p3d8wUXPnH3Gx
 hqVXDvMsH8yUAw5.zj8vCSmYm.2JroeE9I9xTVF6cPBdeYbHBYXEs9hc0oSA
 8
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 10:34:46 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Xi Wang <xi.wang@gmail.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
In-Reply-To: <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
Message-ID: <alpine.DEB.2.00.1202141032410.22250@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
 <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda>
 <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Xi Wang wrote:

> On Feb 14, 2012, at 10:02 AM, Christoph Lameter wrote:
> > We could also catch these issues with BUG() or WARN_ON() and then return
> > zero.
>
> You cannot have SAFE_ARRAY_SIZE return 0 when an integer overflow
> occurs.

You can if you check the results later. A zero size return would be an
indication of an error. No need to pass it on to kmalloc.

> Besides, BUG() still allows DoS attacks and WARN_ON() would flood
> the log, especially if n is controlled from user space.  Neither
> seems appropriate here.

We have means at various level to control the "flood."

