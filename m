Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0GEOub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 10:50:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab0GEOua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 10:50:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] nilfs2: remove BKL uses
Date: Mon, 5 Jul 2010 16:50:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <jblunck@suse.de>
References: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007051650.23761.arnd@arndb.de>
X-Provags-ID: V02:K0:w9rLfWHU/4xmlCzAvnsmH3B4cPK20A8qwRUf8HB+aU3
 eOP5bnzzjlzzvCyzrqZhBpIqeYzBQa9P2zlMq+cC+0hODiHph5
 2rchU+YdOM/GS2WOkU7nPV4QwvjcXwTdQ9Q83z4s5t0XusV+Mu
 sWwHCMQ/IDPiUup+7jw+dyI8gVBcBkg/yzRpRt1hQQg3ivxOcl
 oB5f5BBFgpQpu/TNd+QWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 July 2010, Ryusuke Konishi wrote:
> Nilfs has BKL uses in its put_super and remount functions, but none of
> them are necessary, just came from earlier push downs.  This
> eliminates the BKL uses from nilfs.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This looks good, but there is a another patch series pushing the BKL
into the get_sb and fill_super operations, which should be the final
pushdown for file systems. I wonder if there is a way to find a
shortcut on this so we don't need to add it first just to have you
go through the effort of removing it again.

	Arnd
