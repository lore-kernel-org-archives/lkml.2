Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0IWNS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:18:59 -0400
Received: from borg.medozas.de ([188.40.89.202]:39062 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0IWNS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:18:58 -0400
Date: Thu, 23 Sep 2010 15:18:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Neil Brown <neilb@suse.de>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
In-Reply-To: <alpine.LNX.2.01.1009021625050.14798@obet.zrqbmnf.qr>
Message-ID: <alpine.LNX.2.01.1009231515580.31650@obet.zrqbmnf.qr>
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
 <alpine.LNX.2.01.1009021513040.10859@obet.zrqbmnf.qr> <20100902233200.586fcb31@notabene> <alpine.LNX.2.01.1009021625050.14798@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On ??, Miklos Szeredi wrote:
On Thursday 2010-09-02 16:25, Jan Engelhardt wrote:
>>
>>There ought to be a reason that other implementations offer
>>doing multiple branches with a single vfsmount.
>
>overdesign

However, those implementations offer changing the branch configuration
on the fly, e.g. pulling "out" a branch in the middle. With
"two-branches only" overlayfs, a multi-branch layout would be
multiple vfsmounts describable by something like "(((a b) c) d)".
Say you want to remove branch B. (Supposedly) works today in
aufs/unionfs. How do you pull it off with overlayfs? You can't
umount the (a b) vfsmount because it is used by c.
