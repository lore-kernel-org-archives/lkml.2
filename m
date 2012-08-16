Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab2HPTTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:19:41 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45091 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2HPTTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:19:39 -0400
Date: Thu, 16 Aug 2012 15:19:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, bharrosh@panasas.com,
        bhalevy@tonian.com, Andrew Morton <akpm@linux-foundation.org>,
        adilger.kernel@dilger.ca, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/8] ext3: remove lock/unlock super
Message-ID: <20120816191909.GC31346@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Marco Stornelli <marco.stornelli@gmail.com>, bharrosh@panasas.com,
	bhalevy@tonian.com, Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, hirofumi@mail.parknet.co.jp,
	mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
	hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <502CC4BA.3040702@gmail.com>
 <20120816163904.GA17526@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816163904.GA17526@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:39:04PM +0200, Jan Kara wrote:
> On Thu 16-08-12 12:00:26, Marco Stornelli wrote:
> > From: Marco Stornelli <marco.stornelli@gmail.com>
> > 
> > Replaced lock and unlock super with a new fs mutex s_lock.
>   Hum, is the lock needed at all? Remount & unfreeze both run with s_umount
> held for writing. Thus we already have exclusion between these two calls.
> The same seems to hold for ext4 BTW.

Agreed, it's not clear lock_super() is needed at all for ext4 at this
point.

	     	       		       	      - Ted
