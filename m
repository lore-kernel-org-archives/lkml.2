Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1AaSl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:41:59 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44377 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1AaSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:41:58 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -V1 0/7] Buffered write and writeable mmap support for 9P
In-Reply-To: <E1PjqD4-0000dZ-UN@pomaz-ex.szeredi.hu>
References: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1PjqD4-0000dZ-UN@pomaz-ex.szeredi.hu>
User-Agent: Notmuch/0.5-64-gc3ae51d (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Tue, 01 Feb 2011 00:11:51 +0530
Message-ID: <877hdk9aq8.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 10:38:10 +0100, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sun, 30 Jan 2011, Aneesh Kumar K.V wrote:
> > The patch series implement buffered write and writeable mmap for 9P
> 
> P9 is supposed to work with servers on the local machine, right?

Yes

> 
> In that case you need to think about various deadlock scenarios.  An
> example: the P9 server needs a large order allocation while serving
> the buffered write request.  That may trigger the page reclaim and go
> into synchronous writeback, possibly waiting on the exact page which
> the P9 server is just trying to finish writing out.
> 
> This is not easy to deal with, see commit 3be5a52b for the fuse
> solution.  I'm not saying it's the only way, there may be a better
> one.
> 

Thanks for the commit info. I will look at the details and see how best
we can solve this in 9P

-aneesh
