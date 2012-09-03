Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2ICSrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:47:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2ICSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:47:35 -0400
Date: Mon, 3 Sep 2012 20:47:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix memset in NFS zap caches
Message-ID: <20120903184734.GU16230@one.firstfloor.org>
References: <20120903183515.GT16230@one.firstfloor.org> <4FA345DA4F4AE44899BD2B03EEEC2FA908F81A8E@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA908F81A8E@SACEXCMBX04-PRD.hq.netapp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, this is a gcc bug.
> 
> NFS_COOKIEVERF(inode) resolves to an array, so the current code is
> correct. The above change will cause the 2nd half of the array to remain
> uninitialised...

Are you sure?

include/linux/nfs_fs.h:268:static inline __be32 *NFS_COOKIEVERF(const struct inode *inode)

That doesn't look like an array type to me. 

-Andi

