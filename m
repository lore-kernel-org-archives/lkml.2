Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1CVUGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:06:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34126 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1CVUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:06:41 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
In-reply-to: <20110322195331.GY22723@ZenIV.linux.org.uk> (message from Al Viro
	on Tue, 22 Mar 2011 19:53:31 +0000)
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
 <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
 <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu>
 <20110322190002.GW22723@ZenIV.linux.org.uk>
 <E1Q27U5-0001eO-AL@pomaz-ex.szeredi.hu> <20110322195331.GY22723@ZenIV.linux.org.uk>
Message-Id: <E1Q27qg-0001kq-IO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 21:06:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Al Viro wrote:
> Proceeding with rename is not interesting; proceeding with copyup is.
> 
> Who said that by the time we get to copy_up_locked you will still have
> dentry (and upper) match lowerpath?  Or that ->d_parent on overlay and
> on upper will change in sync, for that matter - there are two d_move()
> calls involved...

If rename is involved, than rename itself already did the copy up.
And that's checked before proceeding with the actual copy up.  If
there was no rename, then that guarantees that things are in sync, at
least for the duration of the copy up.

Is that not enough?

Thanks,
Miklos
