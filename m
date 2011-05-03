Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1ECPlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:41:49 -0400
Received: from 236.121.91-79.rev.gaoland.net ([79.91.121.236]:33608 "EHLO
	mx.synack.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1ECPlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:41:47 -0400
From: Samir Bellabes <sam@synack.fr>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        hadi@cyberus.ca, kaber@trash.net, zbr@ioremap.net, root@localdomain.pl
Subject: Re: [RFC v3 01/10] lsm: add security_socket_closed()
References: <1304432663-1575-1-git-send-email-sam@synack.fr>
	<1304432663-1575-2-git-send-email-sam@synack.fr>
	<201105040029.IGA98088.SHOVQFLOMJtOFF@I-love.SAKURA.ne.jp>
Date: Tue, 03 May 2011 17:41:45 +0200
In-Reply-To: <201105040029.IGA98088.SHOVQFLOMJtOFF@I-love.SAKURA.ne.jp>
	(Tetsuo Handa's message of "Wed, 4 May 2011 00:29:29 +0900")
Message-ID: <87wri73i6e.fsf@synack.fr>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Samir Bellabes wrote:
>> Allow a module to update security informations when a socket is closed.
> Is security_inode_free() too late for doing it?
>
> static void ccs_inode_free_security(struct inode *inode)
> {
>         if (inode->i_sb && inode->i_sb->s_magic == SOCKFS_MAGIC)
>                 ccs_update_socket_tag(inode, 0);
> }

I don't think it's too late.
But in sock_close() we are sure to deal with a inode which is a socket.

In ccs_inode_free_security(), we need to add small to check if the inode
is a socket or something else.

sam
