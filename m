Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2LXLz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 06:55:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LXLz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 06:55:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: correct error message on failure of debugfs_create_dir
Date: Mon, 24 Dec 2012 11:55:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-13-git-send-email-sasha.levin@oracle.com> <20121221075909.GA15739@amit.redhat.com>
In-Reply-To: <20121221075909.GA15739@amit.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212241155.46866.arnd@arndb.de>
X-Provags-ID: V02:K0:E5uXOXe3cljLzTb/InG+5aJdl1a+QoQyusG8Y5yFVkk
 h9H8VaGD2scaGp8lzPA61bIw5S8ZU3YM5fsEmF3iaynLszQBu2
 c7TZ4IFjiREkjENE4qB+VVehe/mwYz7Qd0PrPMXJtD5uN3oEi7
 eJeQ1dwJP6JUi/jcBXmM+5zL4POftgdafmgSBVx6zQX1XVvRg3
 KfR/GX/glIhTV7aabtxTWnlrZL5RKQ91aMM0zJCsroPOZ+qGgC
 D4vCONYYvGi4yzI76T/RYhyJs0iT0NKUwjyLCxDQBxqFsFUiRV
 PF02PHNzUHjzP5crrPK9836VJH+iIeJQOF5akloIW9jogoPMrU
 x848nMmLR4GgGXDZ5EWI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2012, Amit Shah wrote:
> On (Thu) 20 Dec 2012 [14:11:21], Sasha Levin wrote:
> > debugfs_create_dir() returns NULL if it fails, there's little point in
> > calling PTR_ERR on it.
>
> debugfs_create_dir() does return an error value if debugfs is not
> enabled.
> 
> This check for !pdrvdata.debugfs_dir should infact use
> IS_ERR_OR_NULL().  Care to submit a patch for that?

How about we fix the stub instead to return NULL when debugfs is disabled?

	Arnd
