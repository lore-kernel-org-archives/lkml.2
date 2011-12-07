Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1LGIMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:12:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41067 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1LGIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:12:09 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx+qUuPh7kRXVqMXeE-yZY+LddnqOFiVp3MkVuwvNnnKw@mail.gmail.com>
References: <alpine.DEB.2.00.1112061619190.11925@skynet.skynet.ie>
	<CA+55aFyFar45vTWb33FnJ1xv4zT+9XfnKBs=Xwx6-5O-RBHO4Q@mail.gmail.com>
	<CAPM=9twbX+eDG=DE8FSU7HUoe1dQ=9bx1QQw5T6nKAjQdSgi4w@mail.gmail.com>
	<CA+55aFx+qUuPh7kRXVqMXeE-yZY+LddnqOFiVp3MkVuwvNnnKw@mail.gmail.com>
Date: Wed, 7 Dec 2011 08:12:08 +0000
Message-ID: <CAPM=9tw0u=Wt=ZiaqWQ5ahPwjH3Dh-18s08SHUVN-eP3Uj5a+w@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So having looked at the patch itself, I don't dislike the notion of
> making sure certain fields are nicely initialized. So I don't hate the
> patch itself, but quite frankly, to me it doesn't smell even
> *remotely* like "regression fix". I don't think this is something that
> has ever worked.

Well just for completeness I tracked it down to
724c80e1d630296d1324859e964d80d35007d83c
which git describe shows as v2.6.36-rc5-456-g724c80e, so while it is a
technical regression, it took a long time for anyone to notice.

I think we probably need a more invasive patch in any case, as there
is still a race between when the drm midlayer calls pci_set_master and
the sanity enforcement, which we should close by moving pci_set_master
into the drivers (midlayer design yet again for the win).

so I'll leave it for -next.

Dave.
