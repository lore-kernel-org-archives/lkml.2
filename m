Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab2AIR1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:27:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40150 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2AIR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:27:09 -0500
Date: Mon, 9 Jan 2012 17:27:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, gregkh@suse.de, hch@infradead.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120109172707.GW23916@ZenIV.linux.org.uk>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 11:58:54AM +0100, Miklos Szeredi wrote:

> This patch adds a new dentry flag that is set when the dentry is removed
> from the lru and put on the list being processed by
> shrink_dentry_list().  The flag is cleared in dentry_lru_del() which is
> called if the dentry gets a new reference just before it's pruned.

Umm...  In principle, I like that variant, provided that you send it with
sane commit message.  Explicit description of the conditions when new
flag is set will probably turn out to be very useful several months down
the road, so...  Unless I'm misreading you, it should be something along
the lines of "flag is set if and only if dentry->d_lru is currently a part of
tmp cyclic list of some ongoing __shrink_dcache_sb() instance", preferably
without torturing the langauge so much...
