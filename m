Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0IFRQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:16:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34289 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0IFRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:16:49 -0400
To: NeilBrown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <20100906005029.20775.56925.stgit@localhost.localdomain> (message
	from NeilBrown on Mon, 06 Sep 2010 10:50:29 +1000)
Subject: Re: [PATCH 05/10] ovl: make sure fsync is never called on the lower
	filesystem.
References: <20100906004829.20775.68828.stgit@localhost.localdomain> <20100906005029.20775.56925.stgit@localhost.localdomain>
Message-Id: <E1OsfJG-0005kR-Bl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 19:16:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010, NeilBrown wrote:
> If we open a directory O_RDONLY, ->realfile could be on the lower
> filesystem.
> While fsync is not likely to be called on such a file, we should make
> sure never to pass the fsync down as we are treating the lower
> filesystem as read-only.

Why not?  fsync() works fine on an r/o filesystem.  It doesn't do
much, probably, but that's not a reason to add additional complexity.

Thanks,
Miklos
