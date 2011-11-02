Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab1KBPTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:19:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:34919 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab1KBPTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:19:09 -0400
Date: Wed, 2 Nov 2011 11:19:03 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Andy Lutomirski <luto@amacapital.net>, Andreas Dilger <adilger@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] mm: Improve cmtime update on shared writable mmaps
Message-ID: <20111102151903.GA15045@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andy Lutomirski <luto@amacapital.net>,
	Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
 <6e365cb75f3318ab45d7145aededcc55b8ededa3.1319844715.git.luto@amacapital.net>
 <20111101225342.GG18701@quack.suse.cz>
 <CALCETrW3ZZ=474cXY0HH1=fHTwKJUo--ufPfD1WLpGRC4_CPrw@mail.gmail.com>
 <20111102150200.GC31575@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102150200.GC31575@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 04:02:00PM +0100, Jan Kara wrote:
>   That's a good question. Locking of i_flags was always kind of unclear to
> me. They are certainly read without any locks and in the couple of places
> where setting can actually race VFS uses i_mutex for serialization which is
> kind of overkill (and unusable from page fault due to locking constraints).
> Probably using atomic bitops for setting i_flags would be needed.

Adding a set of inode_{test,set,clear}_flag() inline functions, and
then converting accesses of i_flags to use them would be a great
cleanup task.  It's been on my mental todo list for a while, but it's
a pretty invasive change.  What we have right now is definitely racy,
though, and we only get away with it because i_flags changes happen
relatively rarely.  Fixing this would be definitely be a Good Thing.

						- Ted
