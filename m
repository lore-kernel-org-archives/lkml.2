Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0INVZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 17:25:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57551 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab0INVZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 17:25:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Remove BKL from fs/locks.c
Date: Tue, 14 Sep 2010 23:24:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201009142206.54130.arnd@arndb.de> <201009142239.02904.arnd@arndb.de> <AANLkTimK5kesHJV3mspRch-YVe8uRT=ypqNMHr2L9wHC@mail.gmail.com>
In-Reply-To: <AANLkTimK5kesHJV3mspRch-YVe8uRT=ypqNMHr2L9wHC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009142324.16074.arnd@arndb.de>
X-Provags-ID: V02:K0:pqh4iNYrwrxNCko6jNHg1ffmkbsP8KscLIPPP7OXcWZ
 gSIa5tIvJ7FMAKZl6zPXRVcHeOm5ymjRzqUkgrB2FcmvECIphR
 yPH+iNgzuETTOeCKHm7bPyLfiWEwfJvEuBcUUKThmUTdeIiCfD
 iP2FLqpZBvGefrdRyEL8omD7ERoTLR5k2TPARzSsXU06f1uKdY
 TI/QzRnmfgH7D6D21s6gA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 September 2010 22:53:31 Linus Torvalds wrote:
> Oh well. I guess there's no incremental way to do things sanely. And
> nobody has patches to fix those users, I guess.

The only critical user is fs/lockd, I can easily handle the rest.
When I talked to Bruce and Trond during LinuxCon, they told me that
it should be possible to separate the bits of fs/lockd that lock
against fs/locks.c and convert the former to use lock_flocks().

That would be enough to actually apply this patch without the
nasty CONFIG_BKL check and with changes to the few other
consumers of file locks. My original plan was to have my current
patch in -next until that happens.

	Arnd
