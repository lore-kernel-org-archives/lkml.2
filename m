Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0KURht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:37:49 -0500
Received: from thunk.org ([69.25.196.29]:53161 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab0KURhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:37:48 -0500
Date: Sun, 21 Nov 2010 12:37:26 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
Message-ID: <20101121173726.GG23423@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Minchan Kim <minchan.kim@gmail.com>, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
References: <20101121112611.GB4267@deepthought.bhanu.net>
 <20101121133024.GF23423@thunk.org>
 <20101121153949.GD20947@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121153949.GD20947@barrios-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 12:39:49AM +0900, Minchan Kim wrote:
> 
> I think it's no problem. 
> 
> That's because migration always holds lock_page on the file page.
> So the page couldn't remove from radix. 

It may be "ok" in that it won't cause a race, but it still leaves an
unsightly warning if LOCKDEP is enabled, and LOCKDEP warnings will
cause /proc_lock_stat to be disabled.  So I think it still needs to be
fixed by adding rcu_read_lock()/rcu_read_unlock() to
migrate_page_move_mapping().

      	 					     - Ted
