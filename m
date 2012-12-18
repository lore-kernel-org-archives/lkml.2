Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2LRB5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:57:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36760 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2LRB5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:57:07 -0500
Date: Tue, 18 Dec 2012 01:57:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
Message-ID: <20121218015705.GH4939@ZenIV.linux.org.uk>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 05:10:21PM -0800, Andy Lutomirski wrote:
> I want to change inode->i_flags access to be atomic -- there are some
> locking oddities right now, I think, and I want to use a new inode
> flag to signal mtime updates from page_mkwrite.  The problem is that
> i_flags is an unsigned int, and making it an unsigned long seems like
> a waste, but there aren't any u32 atomic bitops.

... and atomic accesses cost more.  A lot more on some architectures.
FWIW, atomic_t *is* 32bit on 32bit architectures, which still doesn't
make it a good idea.
