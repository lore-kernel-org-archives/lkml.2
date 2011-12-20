Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1LTWqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:46:21 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:32791 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab1LTWqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:46:18 -0500
Date: Tue, 20 Dec 2011 17:45:58 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Djalal Harouni <tixxdz@opendz.org>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] mm: add missing mutex lock arround notify_change
Message-ID: <20111220224558.GA27615@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Djalal Harouni <tixxdz@opendz.org>, Hugh Dickins <hughd@google.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Neil Brown <neilb@suse.de>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
References: <20111216112534.GA13147@dztty>
 <20111216125556.db2bf308.akpm@linux-foundation.org>
 <20111217214137.GY2203@ZenIV.linux.org.uk>
 <20111217221028.GZ2203@ZenIV.linux.org.uk>
 <20111220220901.GA1770@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220220901.GA1770@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just took a closer look, and we don't need to take immediate action;
there is no security issue here were someone could modify a writable
suid file as I had originally feared.  It's not as obvious as it could
be because of how the code is broken up, but in mext_check_arguments()
in fs/ext4/move_extent.c, we return with an error if the donor file
has the SUID or SGID bit set, so we'll never actually end up calling
file_remove_suid().  So in fact the right patch is just to remove the
call to file_remove_suid() altogether.

						- Ted
