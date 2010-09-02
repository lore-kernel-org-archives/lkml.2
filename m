Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0IBOZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:25:50 -0400
Received: from borg.medozas.de ([188.40.89.202]:50786 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0IBOZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:25:48 -0400
Date: Thu, 2 Sep 2010 16:25:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Neil Brown <neilb@suse.de>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
In-Reply-To: <20100902233200.586fcb31@notabene>
Message-ID: <alpine.LNX.2.01.1009021625050.14798@obet.zrqbmnf.qr>
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
 <alpine.LNX.2.01.1009021513040.10859@obet.zrqbmnf.qr> <20100902233200.586fcb31@notabene>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2010-09-02 15:32, Neil Brown wrote:
>> 
>> Oh and I what I like to see is support for multiple readonly branches :)
>
>I think we very nearly have that, assuming I understand your requirement
>correctly.
>The lower filesystem can itself be an overlay, providing it is mounted
>read-only.
>
>So if /mnt/ro1 /mnt/ro2 /mnt/ro3 are all read-only branches then
>
> mount -o ro,lowerdir=/mnt/ro1,upperdir=/mnt/ro2 meaninglessstring /mnt/ov1
> mount -o ro,lowerdir=/mnt/ov1,upperdir=/mnt/ro3 meaninglessstring /mnt/ov2
> mount -o lowerdir=/mnt/ov2,upperdir=/mnt/rw ignoreme /mnt/overlay
>
>and /mnt/overlay will be the combination of 3 read-only filesystems and one
>writable one.
>(this doesn't work with the code as-is, but it is really just a few bug-fixes
>away).

There ought to be a reason that other implementations offer
doing multiple branches with a single vfsmount.
