Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab1JNOms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:42:48 -0400
Received: from natasha.panasas.com ([67.152.220.90]:58052 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab1JNOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:42:47 -0400
Message-ID: <4E9848C1.8040306@panasas.com>
Date: Fri, 14 Oct 2011 16:35:45 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NFS list <linux-nfs@vger.kernel.org>
Subject: Problems with Kconfig select across directories
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this weird problem with Kconfig.

In fs/exofs/Kconfig I have:

# Library to be selected by users
config ORE
	tristate

Then
config EXOFS_FS
	tristate "exofs: OSD based file system support"
	depends on SCSI_OSD_ULD
	select ORE
	help ...

So far so good. Choosing EXOFS_FS in xmenuconfig works fine as expected.
But now I add another user say: (It's more complicated but even below does
not work)

config NFS_FS
	tristate "NFS client support"
	depends on INET && FILE_LOCKING
	select LOCKD
	select SUNRPC
	select NFS_ACL_SUPPORT if NFS_V3_ACL
	select ORE
	help ...

This does not work. The ORE is not compiled and MODPOST complains.
(Given EXOFS_FS is not selected since then it will work)

What am I doing wrong? Why can't I "select" in fs/nfs/Kconfig
an option in fs/exofs/Kconfig? What can I do different?

Thanks
Boaz
