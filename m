Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1EWBLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:11:25 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:34190 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1EWBLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:11:21 -0400
Date: Sun, 22 May 2011 21:11:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Vivek Haldar <haldar@google.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: do not normalize block requests from fallocate.
Message-ID: <20110523011117.GE10009@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1305321545-17214-1-git-send-email-haldar@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305321545-17214-1-git-send-email-haldar@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 02:19:05PM -0700, Vivek Haldar wrote:
> Currently, an fallocate request of size slightly larger than a power of
> 2 is turned into two block requests, each a power of 2, with the extra
> blocks pre-allocated for future use. When an application calls
> fallocate, it already has an idea about how large the file may grow so
> there is usually little benefit to reserve extra blocks on the
> preallocation list. This reduces disk fragmentation.
> 
> Tested: fsstress. Also verified manually that fallocat'ed files are
> contiguously laid out with this change (whereas without it they begin at
> power-of-2 boundaries, leaving blocks in between). CPU usage of
> fallocate is not appreciably higher. In a tight fallocate loop, CPU
> usage hovers between 5%-8% with this change, and 5%-7% without it.
> 
> Signed-off-by: Vivek Haldar <haldar@google.com>

Applied, with a minor change to avoid a bit assignment conflict with
the punch patches.

Also, I changed the commit message to note that using a file aging
simulator which filled the file system to 70%, the percentage of free
extents greater than 8MB (as measured using e2freefrag) increased from
38.8% without this commit, to 69.4% with this commit.

      	      	   	      	    	      - Ted
