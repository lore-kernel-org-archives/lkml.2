Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0FVQc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:32:26 -0400
Received: from www.sr71.net ([198.145.64.142]:41320 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0FVQcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:32:23 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 12:32:23 EDT
Subject: Re: [PATCH V3 3/8] Cleancache: core ops functions and configuration
From: Dave Hansen <dave@sr71.net>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@Sun.COM, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
In-Reply-To: <20100621231939.GA19505@ca-server1.us.oracle.com>
References: <20100621231939.GA19505@ca-server1.us.oracle.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 22 Jun 2010 09:26:28 -0700
Message-ID: <1277223988.9782.20.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 16:19 -0700, Dan Magenheimer wrote:
> --- linux-2.6.35-rc2/include/linux/cleancache.h 1969-12-31 17:00:00.000000000 -0700
> +++ linux-2.6.35-rc2-cleancache/include/linux/cleancache.h      2010-06-21 14:45:18.000000000 -0600
> @@ -0,0 +1,88 @@
> +#ifndef _LINUX_CLEANCACHE_H
> +#define _LINUX_CLEANCACHE_H
> +
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +
> +struct cleancache_ops {
> +       int (*init_fs)(size_t);
> +       int (*init_shared_fs)(char *uuid, size_t);
> +       int (*get_page)(int, ino_t, pgoff_t, struct page *);
> +       void (*put_page)(int, ino_t, pgoff_t, struct page *);
> +       void (*flush_page)(int, ino_t, pgoff_t);
> +       void (*flush_inode)(int, ino_t);
> +       void (*flush_fs)(int);
> +};
> + 

How would someone go about testing this code?  Is there an example
cleancache implementation?

-- Dave

