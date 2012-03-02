Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030639Ab2CBUp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:45:26 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:34185 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030614Ab2CBUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:45:24 -0500
Date: Fri, 2 Mar 2012 15:45:21 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Neil Clarkson <neilaclarkson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 bug? last write time precedes last mount time on a
 writable volume!
Message-ID: <20120302204521.GD22215@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Neil Clarkson <neilaclarkson@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CADzG2TC8y=sYVYx0rVLAo_o6Mo2tjMOJYAw97ZhKAmNX555a6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADzG2TC8y=sYVYx0rVLAo_o6Mo2tjMOJYAw97ZhKAmNX555a6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 12:39:57PM +0000, Neil Clarkson wrote:
> Isn't the s_wtime field of the ext4 superblock supposed to show the
> time, in seconds since the epoch, of the last write? It isn't
> happening!

It shows the last time the superblock has been modified, and one of
the things that we've been doing lately has been to optimize ext4 so
that it writes to the superblock *much* less often.  It was a
performance bottleneck to be constantly updating the number of free
blocks in the superblock each time we write to a new block, for
example --- or update the superblock to update the number of free
inodes each time we allocate a new inode.

Is there a reason why you particularly care about s_wtime being
updated?

					- Ted
