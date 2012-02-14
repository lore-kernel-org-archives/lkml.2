Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761083Ab2BNVbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:31:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59813 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2BNVbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:31:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1202141503470.29019@router.home>
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
	<CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com>
	<alpine.DEB.2.00.1202141503470.29019@router.home>
Date: Tue, 14 Feb 2012 23:31:03 +0200
X-Google-Sender-Auth: 6VLTwp0qA6ZiGwYGllXOjRQDuW0
Message-ID: <CAOJsxLEVy9AyoU56n6F066gX28b_EJ1Ue=Qz+FWMgJL43OWPag@mail.gmail.com>
Subject: Re: Uninline kcalloc
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Xi Wang <xi.wang@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Pekka Enberg wrote:
>> Me neither. I don't think Christoph's SAFE_ARRAY_SIZE() suggestion
>> makes much sense, really. It's more verbose, less obvious API, and
>> doesn't really deal with the overflow case cleanly.

On Tue, Feb 14, 2012 at 11:09 PM, Christoph Lameter <cl@linux.com> wrote:
> IMHO Having a function to deal with the overflow of a multiplication and
> then do an allocation based on the result is a conflation of two different
> things that need to be separate. kcalloc only exists because there is
> an ancient user space function that somehow got a second parameter instead
> of just using the same as malloc().

It's an ancient userspace function that everybody knows how to use.
There really isn't big enough gains from SAFE_ARRAY_SIZE() to justify
a new API. And it's not as if the macro is an elegant way to solve the
problem at hand either.

                                 Pekka
