Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab2BNLMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:12:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54630 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2BNLMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:12:12 -0500
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20120214072017.GF26353@mwanda>
Date: Tue, 14 Feb 2012 06:12:06 -0500
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <57269901-FC81-4276-818E-4C996C5C902A@gmail.com>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 14, 2012, at 2:20 AM, Dan Carpenter wrote:
> I really think that's over thinking things.  Let's just match
> kcalloc() exactly except without zeroing.  The BUILD_BUG_ON() thing
> is an over complication as well.  We haven't needed it for
> kcalloc().

I don't think the BUILD_BUG_ON macro is useful here nor in kcalloc
(besides gcc won't give you much handy information).

Just matching the new non-zeroing array allocator with kcalloc seems
like the right thing to do.  We had quite a few patches that could
be simpler with it.  For now I don't feel like it's necessary to
change the API (e.g., making gfp_t as the first argument), do "smart"
optimizations (e.g., recognizing the first argument is a constant),
nor add more allocators (e.g., to match vmalloc, kmalloc_node).

- xi
