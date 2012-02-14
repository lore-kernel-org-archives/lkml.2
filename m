Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2BNVqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:46:43 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60207 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2BNVqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:46:40 -0500
Subject: Re: Uninline kcalloc
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1202141503470.29019@router.home>
Date: Tue, 14 Feb 2012 16:46:38 -0500
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org> <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home>
To: Christoph Lameter <cl@linux.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 14, 2012, at 4:09 PM, Christoph Lameter wrote:
> IMHO Having a function to deal with the overflow of a multiplication and
> then do an allocation based on the result is a conflation of two different
> things that need to be separate. kcalloc only exists because there is
> an ancient user space function that somehow got a second parameter instead
> of just using the same as malloc().

I don't understand why these kcalloc patches have anything to do
with kmalloc(SAFE_ARRAY_SIZE(...), ...) you proposed.

It also doesn't make much sense to force the caller to check the
result of SAFE_ARRAY_SIZE() or calculate_array_size() before passing
it to kmalloc().  This is too verbose.

- xi
