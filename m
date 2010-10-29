Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0J2G6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:58:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab0J2G6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:58:25 -0400
Date: Fri, 29 Oct 2010 07:58:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix possible use after free in finish_open()
Message-ID: <20101029065819.GQ19804@ZenIV.linux.org.uk>
References: <E1PAMux-0002CG-8a@pomaz-ex.szeredi.hu>
 <E1PAgls-00049P-QS@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PAgls-00049P-QS@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 12:28:48PM +0200, Miklos Szeredi wrote:
> Oops, broken patch.  Here's the correct one.
> 
> ----
> Subject: vfs: fix possible use after free in finish_open()
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> In finish_open() nd->path is used after nameidata_to_filp() already
> released it.  Fix by acquiring a ref to nd->path and releasing after
> the last use.

Nice catch, but I'd do it differently; that is, do not drop reference
in nameidata_to_filp() (and dup it if we do __dentry_open()) and drop
it in callers instead.  Will push in a few.
