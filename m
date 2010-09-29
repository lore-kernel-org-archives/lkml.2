Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0I2HpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:45:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:34967 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab0I2HpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:45:01 -0400
Subject: Re: Odd NFS related SIGBUS (& possible fix)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1285734825.14081.87.camel@pasglop>
References: <1285734825.14081.87.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 17:44:42 +1000
Message-ID: <1285746282.14081.89.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 14:33 +1000, Benjamin Herrenschmidt wrote:

> Now regarding the other bug, unless Trond has an idea already, I think I'll start
> a separate email thread once I've collected more data. I -think- it invalidates it
> because it sees a the server mtime that is more recent than the inode, but the
> server shouldn't be touching at files, so I suspect we get confused somewhere in
> the kernel and I don't know why yet (the code path inside NFS aren't obvious to
> me at this stage).

Ok, so that doesn't happen with current upstream (we were on some
2.6.32.16 based kernel here). I'll figure that out from there.

However, I still think there's a potential erroneous sigbus in the NFS
page_mkwrite() code path unless I'm mistaken.

Cheers,
Ben.


