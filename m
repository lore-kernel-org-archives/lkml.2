Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0DMJb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 05:31:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50018 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0DMJb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:31:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] ext2: Preparation to remove BKL
Date: Tue, 13 Apr 2010 11:31:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jan Blunck <jblunck@suse.de>, Jan Kara <jack@suse.cz>, tytso@mit.edu,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
References: <1271104905-8804-1-git-send-email-jblunck@suse.de> <20100412210127.GE8285@nowhere>
In-Reply-To: <20100412210127.GE8285@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004131131.54650.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/K7P0ZDYqPZ0BZmoUch0f4qOgRmXMs9uF30wU
 J21a8As0OwtEnNKfY0MsQJnPS7ZMg+Qd7pCHthdwtkSeOnxeb+
 vg6sLkAzTYTzWuL35o9yQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 April 2010, Frederic Weisbecker wrote:
> It looks like this is all about .35 material.
> 
> This is going to be hard to have a separate tree to pushdown/remove
> the bkl in the mount path if it depends on the ext2 tree.

The pushdown can be in a separate tree that can be merged independently,
just the final patch removing it in do_new_mount needs to wait
for everything else to get merged first. We have some other patches,
in particular the one that makes CONFIG_BKL modular that have to
wait for other patches and should probably just be applied separately
rather than merged from a bisectable git tree.

	Arnd
