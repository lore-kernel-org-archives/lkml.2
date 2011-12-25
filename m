Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab1LYAFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 19:05:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab1LYAFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 19:05:46 -0500
Date: Sun, 25 Dec 2011 00:05:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: file locking fix for 3.2
Message-ID: <20111225000542.GS23916@ZenIV.linux.org.uk>
References: <20111224215012.GA23495@fieldses.org>
 <20111224225525.GR23916@ZenIV.linux.org.uk>
 <20111224235035.GA23711@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111224235035.GA23711@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 06:50:35PM -0500, J. Bruce Fields wrote:

> Then you're returning -ENOMEM in a case when we really didn't need to do
> an allocation, but is that really a problem?  It's a rare case, and
> opens can already fail with -ENOMEM for other reasons, and I'd rather
> not have the extra hair.

I'm certainly OK with that variant; if the folks maintaining fs/locks.c
are happy with it, I'd suggest going for it.  Note that you don't need
to touch locks_conflict() call at all if you bail out early on allocation
failure and it's definitely simpler and cleaner that way.
