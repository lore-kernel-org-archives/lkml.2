Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2BNHfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:35:10 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40312 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644Ab2BNHfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:35:08 -0500
Date: Tue, 14 Feb 2012 09:35:01 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Christoph Lameter <cl@linux.com>, Xi Wang <xi.wang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
In-Reply-To: <20120214072017.GF26353@mwanda>
Message-ID: <alpine.LFD.2.02.1202140933580.2721@tux.localdomain>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
 <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home>
 <20120214072017.GF26353@mwanda>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Dan Carpenter wrote:
> SAFE_ARRAY_SIZE() would return the size if there were no overflow
> and -1 on errors?  We can't return zero on errors because there are
> a lot of places which do zero size allocations and it's valid.  It
> seems ugly.
>
> I really think that's over thinking things.  Let's just match
> kcalloc() exactly except without zeroing.  The BUILD_BUG_ON() thing
> is an over complication as well.  We haven't needed it for
> kcalloc().

It is and we're not going to phase out a userspace-like kcalloc() API with 
something as verbose as SAFE_ARRAY_SIZE().

 			Pekka
