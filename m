Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab1CXPYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:24:14 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:58141 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1CXPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:24:13 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
To: "Hans-Peter Jansen" <hpj@urpla.net>
Cc: Xianghua Xiao <xiaoxianghua@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
        linux-kernel@vger.kernel.org, neilb@suse.de
In-Reply-To: <201103230013.41936.hpj@urpla.net>
References: <20110322152602.053930811@szeredi.hu> <4D88E8EF.8000001@openwrt.org> <AANLkTim-_h9_mp3hPQXndTc3gR+AJKj+keoN2yDZV2Sr@mail.gmail.com> <201103230013.41936.hpj@urpla.net>
Date: Fri, 25 Mar 2011 00:24:26 +0900
Message-ID: <12510.1300980266@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(removed aufs-users ML since it is restricted to its members only)

"Hans-Peter Jansen":
> and aufs2: it's a minimalistic version of a layered filesystem, being=20
	:::

Thanks reminding us about aufs. :-)

As far as I know, overlayfs has some problems (minors?) similar to
UnionMount.
- for users, the inode number may change silently. eg. copy-up.
- hardlinks may break by copy-up.
- read(2) may get an obsoleted filedata (fstat(2) for metadata too).
- fcntl(F_SETLK) may be broken by copy-up.
- unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
  open(O_RDWR).

And I noticed overlayfs adopts overriding credentials for copy-up.
Although I didn't read about credintials in detail yet, is it safe?
For example, during copy-up other thread in the same process may gain
the higher capabilities unexpectedly? Signal hander in the process too?

I just have read overlayfs once a long time ago, so I may be
misunderstanding.
But I have no objection to merge overlayfs into mainline.


Also I'd like to thank you Pete about mentioning the recent disaster in
Japan.


J. R. Okajima
