Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175Ab2BNU6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:58:13 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35064 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760922Ab2BNU6J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:58:09 -0500
MIME-Version: 1.0
In-Reply-To: <20120214124518.f42bc03e.akpm@linux-foundation.org>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	<4F33C7D7.1060801@kernel.dk>
	<32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
	<4F33CEAE.60400@gmail.com>
	<alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
	<20120209150652.5b1d19dc.akpm@linux-foundation.org>
	<FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
	<alpine.DEB.2.00.1202130958470.23562@router.home>
	<20120213194446.GD26353@mwanda>
	<alpine.DEB.2.00.1202131424020.25908@router.home>
	<20120214072017.GF26353@mwanda>
	<alpine.DEB.2.00.1202140858080.20013@router.home>
	<8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
	<alpine.DEB.2.00.1202141032410.22250@router.home>
	<ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
	<alpine.DEB.2.00.1202141329360.24883@router.home>
	<20120214124518.f42bc03e.akpm@linux-foundation.org>
Date: Tue, 14 Feb 2012 22:58:08 +0200
X-Google-Sender-Auth: k-MxoYBfyB7DayB68WQuIEG_0cE
Message-ID: <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com>
Subject: Re: Uninline kcalloc
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Xi Wang <xi.wang@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 10:45 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 14 Feb 2012 13:33:40 -0600 (CST)
> Christoph Lameter <cl@linux.com> wrote:
>
>> Subject: Uninline kcalloc
>>
>> kcalloc is not used in performance critical ways. So it does not need to
>> be inline. If we would add diagnostics to track the overflow occurrences
>> then such code would be replicated at all call sites in the kernel.
>
> Uninlining kcalloc() seems reasonable.  But if we're going to uninline
> kcalloc() then we also should uninline kmalloc_array().

Well, kcalloc() used to be uninline and we made it inline on purpose
at some point. I don't have a git tree here so I can't check. IIRC it
had something to do with kernel text size reduction.

> And yes, it's still called kmalloc_array() in my tree.  I've been
> following this discussion for N days waiting for a reason for changing
> the original patch and I ain't seen one yet.

Me neither. I don't think Christoph's SAFE_ARRAY_SIZE() suggestion
makes much sense, really. It's more verbose, less obvious API, and
doesn't really deal with the overflow case cleanly.

                                Pekka
