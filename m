Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0GER1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:27:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:36155 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab0GER10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:27:26 -0400
Date: Mon, 5 Jul 2010 13:27:18 -0400
From: tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Cc: David Howells <dhowells@redhat.com>, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Message-ID: <20100705172718.GE25518@thunk.org>
Mail-Followup-To: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>,
	David Howells <dhowells@redhat.com>, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
 <4C32001F.8060906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C32001F.8060906@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 10:54:07AM -0500, Eric Sandeen wrote:
> 
> ... a stern comment here about not re-ordering since other fs/*/*
> code depends strongly on this order?

A stern warning is needed there, but it's also needed a few lines
further down in the inode flags section where the FS_*_FL flags are
defined.  These were originally ext2-specific inode flags, and it's
become generalized to a fs-independent set of bit fields, but what's
nasty/important to remember is that these flags are also used as
on-disk flags for ext2/3/4, and so extreme care is needed before new
flags are for FS_IOC_GETFLAGS/FS_IOC_SETFLAGS are allocated....

In fact, I'd argue it's much more strongly needed for the FS_*_FL
flags.

						- Ted
