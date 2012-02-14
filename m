Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905Ab2BNPCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:02:08 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:24414 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751007Ab2BNPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:02:06 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QxiiDd8VM1kCU9GTn7WGo1wAp9z6T4IB43SwZ_1GrMPhbpG
 qw3tKklConJhoLxRBvT179kxocR_Hfm6XDDN3KX_mUTPGG45jH0GLJyRXu5l
 fycAcASQGbUtT_fMFbgy9yh_stcD3RZeCBYeEcAOlM4HHPlyXdFZjr.oFDsI
 DsB6ZYvXDknMcp59DHF4G18cibtI0uPDNtbtueDL_S_YL363N1scPcLG7LuG
 s7NYX_5s_4P35dFwDbAb4bP7v9d_uqbZ_QVaJQOB_S1A0wdDOA_68xmBLdvZ
 3X3400mps9hWobkJ.io4mjk6_wfEgjf5x5z9ZDktfbmsG59dcJi8XEjjsnh4
 wVWzaaOx2Zjf3QQ_Ltnru8s90aFDaPMFO5EAhijex2bHJ65C.3VBrUzQ1h0x
 D
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 09:02:01 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Xi Wang <xi.wang@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
In-Reply-To: <20120214072017.GF26353@mwanda>
Message-ID: <alpine.DEB.2.00.1202140858080.20013@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
 <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home>
 <20120214072017.GF26353@mwanda>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Dan Carpenter wrote:

> SAFE_ARRAY_SIZE() would return the size if there were no overflow
> and -1 on errors?  We can't return zero on errors because there are
> a lot of places which do zero size allocations and it's valid.  It
> seems ugly.

We could also catch these issues with BUG() or WARN_ON() and then return
zero.

> I really think that's over thinking things.  Let's just match
> kcalloc() exactly except without zeroing.  The BUILD_BUG_ON() thing
> is an over complication as well.  We haven't needed it for
> kcalloc().

The best thing is to remove kcalloc and get it all cleaned up
with some mechanism to safely calculate the size of an array to be
allocated.

The other way will lead to naming issues and then to a multiplication of
variants of the allocator interface. It makes things difficult to
understand and handle.

Keep it simple by providing a function that determines the array size and
handles any possible error condition.

