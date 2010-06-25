Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0FYUBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:01:23 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:52072 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0FYUBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:01:22 -0400
Subject: Re: Fwd: fs/exec.c core dumping on NFS mounted directory
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Lei Sun <leisun124@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikbQLTC8HLB2m8LoPtZ0JVUzRl6PvRL5yTC0pZV@mail.gmail.com>
References: <AANLkTila2rrYcBUZKwywHTP6g8rsj7Z1ck6LSoC9GaUY@mail.gmail.com>
	 <AANLkTikbQLTC8HLB2m8LoPtZ0JVUzRl6PvRL5yTC0pZV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 16:01:17 -0400
Message-ID: <1277496077.6141.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 2 msgs/h 1 sum rcpts/h 6 sum msgs/h 2 total rcpts 499 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 2ADC86A2C5D9E4B0844959169A766C877686306E
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 229 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 12:32 -0700, Lei Sun wrote:
>   In 2.6.3x, I am logging in as a root and running app from NFS
> mounted directory. The app crashed with 0 bytes core file (I have set
> "ulimit -c unlimited", so it's not an issue).
> 
> Proposed patch:
> 
> --- exec.c 2010-05-19 17:33:16.000000000 -0700
> +++ exec.c.new 2010-05-19 17:33:07.000000000 -0700
> @@ -1859,7 +1859,7 @@
>      * Dont allow local users get cute and trick others to coredump
>      * into their pre-created files:
>      */
> - if (inode->i_uid != current_fsuid())
> + if (inode->i_bytes != 0 && inode->i_uid != current_fsuid())
>         goto close_fail;
> 
>     if (!file->f_op)
> 
... which would go ahead and reintroduce bugzilla entry 3043, but only
for those filesystems that set inode->i_bytes to zero:
           https://bugzilla.kernel.org/show_bug.cgi?id=3043

NACKed...

Trond

