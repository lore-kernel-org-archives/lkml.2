Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab0IEKhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 06:37:55 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:46636 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0IEKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 06:37:54 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/6] overlay filesystem prototype
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
In-Reply-To: <20100903134116.039612691@szeredi.hu>
References: <20100903134116.039612691@szeredi.hu>
Date: Sun, 05 Sep 2010 19:37:10 +0900
Message-ID: <20970.1283683030@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> Changes since the last version:
	:::
>  - get write ref on the upper layer on mount unless the overlay
>    itself is mounted read-only

I think it a good approach.
Although it may be harmless, write-ref will not be put when a user
executes,
- mount -o ro /overlay
- umount /overlay
It will be easy to fix by implementing s_op->remount().


>  - raise capabilities for copy up, dealing with whiteouts and opaque
>    directories.  Now the overlay works for non-root users as well

Interesting approach.
But is it safe? If multi-threaded ap or a signal handler share
the credential, then they may gain incorrect capability.


J. R. Okajima
