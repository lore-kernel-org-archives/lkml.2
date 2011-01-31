Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1AaJiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 04:38:20 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54897 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1AaJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 04:38:19 -0500
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -V1 0/7] Buffered write and writeable mmap support for 9P
References: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <E1PjqD4-0000dZ-UN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 31 Jan 2011 10:38:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jan 2011, Aneesh Kumar K.V wrote:
> The patch series implement buffered write and writeable mmap for 9P

P9 is supposed to work with servers on the local machine, right?

In that case you need to think about various deadlock scenarios.  An
example: the P9 server needs a large order allocation while serving
the buffered write request.  That may trigger the page reclaim and go
into synchronous writeback, possibly waiting on the exact page which
the P9 server is just trying to finish writing out.

This is not easy to deal with, see commit 3be5a52b for the fuse
solution.  I'm not saying it's the only way, there may be a better
one.

Thanks,
Miklos
