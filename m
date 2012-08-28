Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab2H1NEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:04:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2H1NES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:04:18 -0400
Message-ID: <1346149593.4031.8.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: [PATCH] fuse: mark variables uninitialized
From: Miklos Szeredi <mszeredi@suse.cz>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, Brian Foster <bfoster@redhat.com>
In-Reply-To: <1346143083-30710-1-git-send-email-zonque@gmail.com>
References: <1346143083-30710-1-git-send-email-zonque@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Aug 2012 12:26:33 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-28 at 10:38 +0200, Daniel Mack wrote:
> gcc 4.6.3 complains about uninitialized variables in fs/fuse/control.c:
> 
>   CC      fs/fuse/control.o
> fs/fuse/control.c: In function ‘fuse_conn_congestion_threshold_write’:
> fs/fuse/control.c:165:29: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]
> fs/fuse/control.c: In function ‘fuse_conn_max_background_write’:
> fs/fuse/control.c:128:23: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]
> 
> fuse_conn_limit_write() will always return non-zero unless the &val
> is modified, so the warning is misleading. Let the compiler know
> about it by marking 'val' with 'uninitialized_var'.

Thanks, applied.

Miklos


