Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0HPXuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:50:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1093 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab0HPXuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:50:04 -0400
Subject: RE: [PATCH] fs.h: introduce functions to get/set file->private_data
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
In-Reply-To: <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
References: <201008161137.53187.hartleys@visionengravers.com>
	 <20100816231753.GA16546@infradead.org>
	 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 16:50:01 -0700
Message-ID: <1282002601.6518.116.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 18:36 -0500, H Hartley Sweeten wrote:
> It's just a pain trying to figure out where the file 'private_data' is being
> used.

spatch (coccinelle) could help a lot with this style problem.

For instance, here's a grep equivalent for any use
of (struct file) member private_data in directory fs

$ cat t.cocci
@@
struct file *file;
@@

* file->private_data
$ spatch -very_quiet -sp_file t.cocci fs


