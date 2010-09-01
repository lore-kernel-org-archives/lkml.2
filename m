Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0IAULw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:11:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43994 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0IAULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:11:51 -0400
To: Neil Brown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-reply-to: <20100901143333.0b9db01a@notabene> (message from Neil Brown on
	Wed, 1 Sep 2010 14:33:33 +1000)
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
	<20100829144207.4fbf2713@notabene>
	<E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
	<20100830214027.77e197f5@notabene> <20100901143333.0b9db01a@notabene>
Message-Id: <E1Oqtem-0000xW-7t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Sep 2010 22:11:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Neil Brown wrote:
> On Mon, 30 Aug 2010 21:40:27 +1000
> And here is a patch.  It isn't really complete, but I have done enough for
> today.  It at least shows what I am trying to do.

Thanks.

Okay, I see what it's trying to do.  And I can accept the part which
validates that the underlying dentry trees still match the union tree
(wouldn't it be simpler to just d_lookup() and check if the child
matches?)

However redoing the lookup and changing the upperpath and lowerpath
for directories is no good.  Upperpath and lowerpath are constant,
changing them would be like changing dentry->d_inode, the dentry would
suddenly become something else.  That's crazy.

Making sure that evething is in a sane state and erroring out if not
sounds a workable alternative to enforcing no change blindly.
Although no change should probably be the default (e.g. unless a 
"-o dont_enforce_no_change" mount option is given).

Thanks,
Miklos
