Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1CPLq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:46:56 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:53993 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1CPLqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:46:47 -0400
X-AuditID: 12074425-b7c98ae000000a04-a9-4d80a326c20c
Subject: Re: [git pull] VFS - the first pile
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110316072123.GR22723@ZenIV.linux.org.uk>
Date: Wed, 16 Mar 2011 07:46:40 -0400
Cc: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B0CB85F7-23A7-45EA-848E-8B2701545371@mit.edu>
References: <20110315213248.GL22723@ZenIV.linux.org.uk> <20110316061917.GA30195@dastard> <20110316065103.GP22723@ZenIV.linux.org.uk> <20110316072123.GR22723@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 16, 2011, at 3:21 AM, Al Viro wrote:

> BTW, you want to update 005 in there - we are back to correct "maximum
> is 40 symlinks total, 8 levels on nesting" for all syscalls.  Add the
> 41st symlink to your chain in testcase ;-)

Unless there's a way to read out these limits, I'm not sure it's a good idea
to add a test like that to xfstests --- it's too fragile since at some point
we might change what those limits might be.

Also, xfstests is primarily intended to be a file system level stress tester
testing for correctness, and issues of whether we blow up on the 40th, 
41st, or 42nd symlink seems more like an ABI issue --- and even there I'm
not sure the ABI specification should be quite that detailed over what's
allowed and not allowed.

-- Ted

