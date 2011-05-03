Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1ECPaC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:30:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56969 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1ECPaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:30:00 -0400
X-Nat-Received: from [202.181.97.72]:52715 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1304436571.14309
To: sam@synack.fr, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, hadi@cyberus.ca, kaber@trash.net,
        zbr@ioremap.net, root@localdomain.pl
Subject: Re: [RFC v3 01/10] lsm: add security_socket_closed()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1304432663-1575-1-git-send-email-sam@synack.fr>
	<1304432663-1575-2-git-send-email-sam@synack.fr>
In-Reply-To: <1304432663-1575-2-git-send-email-sam@synack.fr>
Message-Id: <201105040029.IGA98088.SHOVQFLOMJtOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 4 May 2011 00:29:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 03052011 #5369088, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samir Bellabes wrote:
> Allow a module to update security informations when a socket is closed.
Is security_inode_free() too late for doing it?

static void ccs_inode_free_security(struct inode *inode)
{
        if (inode->i_sb && inode->i_sb->s_magic == SOCKFS_MAGIC)
                ccs_update_socket_tag(inode, 0);
}
