Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab0CQBZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 21:25:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:58976 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab0CQBZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 21:25:29 -0400
Date: Tue, 16 Mar 2010 21:24:39 -0400
From: tytso@mit.edu
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100317012439.GA8256@thunk.org>
Mail-Followup-To: tytso@mit.edu, Ben Gamari <bgamari.foss@gmail.com>,
	linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
	martin f krafft <madduck@madduck.net>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 08:31:12AM -0700, Ben Gamari wrote:
> Hey all,
> 
> Recently I started using the Xapian-based notmuch mail client for everyday
> use.  One of the things I was quite surprised by after the switch was the
> incredible hit in interactive performance that is observed during database
> updates. Things are particularly bad during runs of 'notmuch new,' which scans
> the file system looking for new messages and adds them to the database.
> Specifically, the worst of the performance hit appears to occur when the
> database is being updated.

What kernel version are you using; what distribution and what version
of that distro are you running; what file system are you using and
what if any mount options are you using?  And what kind of hard drives
do you have?

I'm going to assume you're running into the standard ext3
"data=ordered" entagled writes problem.  There are solutions, such as
switching to using ext4, mounting with data=writeback mode, but they
have various shortcomings.

A number of improvements have been made in ext3 and ext4 since some of
the discussions you quoted, but since you didn't tell us what
distribution version and/or what kernel version you are using, we
can't tell you are using those newer improvements yet.

      	       	   	       	     - Ted
