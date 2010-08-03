Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0HCVYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:24:00 -0400
Received: from mail.perches.com ([173.55.12.10]:2230 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab0HCVX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:23:59 -0400
Subject: Re: [PATCH] isofs: Fix lseek() to position beyond 4 GB
From: Joe Perches <joe@perches.com>
To: Jan Andres <jandres@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100803211814.GA4436@pitr.home.jan>
References: <20100803211814.GA4436@pitr.home.jan>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 14:23:57 -0700
Message-ID: <1280870637.6088.24.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 23:18 +0200, Jan Andres wrote:
> isofs supports files larger than 4 GB by using multi-extent files.
> However an lseek() to a position beyond 4 GB in such a file will
> fail with EINVAL, because s_maxbytes in the isofs superblock is
> initialized to 2^32-1, and generic_file_llseek() checks against
> that value.
> --- linux-2.6.35-j7/fs/isofs/inode.c.orig	2010-08-02 00:11:14.000000000 +0200
> +++ linux-2.6.35-j7/fs/isofs/inode.c	2010-08-03 22:54:38.000000000 +0200
> +	s->s_maxbytes = 0x80000000000;

0x80000000000LL;


