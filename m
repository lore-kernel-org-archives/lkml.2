Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2CDEbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 23:31:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60374 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2CDEbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 23:31:08 -0500
Date: Sun, 4 Mar 2012 05:31:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: torvalds@linux-foundation.org, andi@firstfloor.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know ofany filesystems that depend on the exact VFS 'namehash' implementation?)
Message-ID: <20120304043107.GC22197@one.firstfloor.org>
References: <CA+55aFyMn+gYh2uRPJSAS5n4UbQoY2iqe3peYjVosrP-73oQVA@mail.gmail.com> <201203041127.IDI56216.FHOQMOVLtOFSJF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203041127.IDI56216.FHOQMOVLtOFSJF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2012 at 11:27:01AM +0900, Tetsuo Handa wrote:
> A passer-by's mumble.
> 
> We are discussing about systems with huge "struct dentry" instances where
> selecting a hash list based on "struct qstr"->hash cannot effectively narrow
> down candidates to compare, aren't we?

This is effectively a simple bloom filter. 

Would be only worth it if longer hash chains are common. And if that's the case
we should probably have either a larger table or a better hash (or both)

-Andi
