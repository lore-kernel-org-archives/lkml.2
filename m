Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454Ab1FWUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:39:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56655 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997Ab1FWUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=JUAooxlQVfX5j2V7pzxa5d94VNEZRiKseTFxyF8rMOXzrNOwzTgTuA8t+Q7JHP0boB
         2zAkixt1DC3Qi1SWjRJiubDIWCg7F0EjOKgUZblMQ0bJZPA/6HjfuZSI4LNyw2n0WLGM
         97P+zTbIRsOfrl2+sGPskGXV0dlOs1e+tm8KY=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 23 Jun 2011 16:38:56 -0400
Message-ID: <BANLkTi=ZxHDvhCs8Qki2ZrhCbfY6Mjx5+w@mail.gmail.com>
Subject: Re: linux-next: Tree for June 23 (net/can & i/o)
To: netdev <netdev@vger.kernel.org>, socketcan-core@lists.berlios.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 01:54, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> My fixes tree includes (as an experiment) the early part of
> mmotm-2011-06-22-13-05.
>
> The powerpc allyesconfig (and probably others) is still broken because we
> now build the staging drivers and because of a commit in the net tree.
> The breakage in Linus' tree is fixed by one of Andrew's patches above.
>
> The m68knommu tree lost its conflicts.
>
> The galak tree lost its conflicts.
>
> The net tree gained 2 build failures that I have left (see above).

not sure where this is coming from, but some Blackfin boards now fail with:

drivers/net/can/bfin_can.c: In function 'bfin_can_start_xmit':
drivers/net/can/bfin_can.c:247: error: implicit declaration of function 'writew'
make[3]: *** [drivers/net/can/bfin_can.o] Error 1

at any rate, the usage of writew() in this driver is wrong, so i sent
a patch to fix it.  but since nothing in this file nor in my Blackfin
tree changed, i wonder if whatever common code changed is going to
break other stuff ...
-mike
