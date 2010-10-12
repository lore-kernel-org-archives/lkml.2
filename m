Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0JLTEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:04:43 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42667 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab0JLTEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:04:42 -0400
X-Sasl-enc: d9Xz50lzVNdHqUPAEaf/8NXBAUVsiIWQhuCbVGi8CpRF 1286910281
Date: Tue, 12 Oct 2010 16:04:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [stable] dm-crypt: plain64 IV support for -stable?
Message-ID: <20101012190438.GB16717@khazad-dum.debian.net>
References: <20101012132511.GA24455@khazad-dum.debian.net>
 <20101012141143.GA12143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012141143.GA12143@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Greg KH wrote:
> Which -stable tree?  .27, .32, .35, or any/all of them?  Please be more
> specific when asking for this in the future.

Just 2.6.32.  It is already in 2.6.35, and 2.6.27 is too old for it to
matter.

> > Without it, users of LTS kernels like 2.6.32 are missing important
> > functionality (as in: might not be able to mount some LUKS volumes
> > created on newer kernels).
> 
> Also note that this patch really looks like a "new feature", not a
> bugfix or anything that matches up with what
> Documentation/stable_kernel_rules.txt defines.  So I don't think that it
> really is something to add to a stable kernel.

Using "plain" for IVs on block devices with more than 2^32 blocks will cause
the same IV to be used twice due to roll-over.  This is not a good thing,
although it might be not bad enough to matter much (or it could be a
terrible problem.  Someone who groks crypto for real would have to answer
that).

One cannot fix "plain", or data after the roll-over point becomes unreadable
on any already-existing devices.  Thus, a new IV was added with the fix,
"plain64".

Distros will probably need to backport this, as userspace and docs are
already starting to tell users to use aes-xts-plain64 and not aes-xts-plain.
They will use them in their portable HDs, and then will not be able to read
them back in various stable distros.   Might as well do it upstream where it
will benefit everybody...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
