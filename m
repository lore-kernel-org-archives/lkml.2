Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab1JYNXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:23:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57185 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399Ab1JYNXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:23:00 -0400
Date: Tue, 25 Oct 2011 09:22:56 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] ext4: Prevent stack overrun in ext4_file_open when
 recording last known mountpoint
Message-ID: <20111025132256.GK31921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
 <20111021211818.10784.77127.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021211818.10784.77127.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:18:18PM -0700, Darrick J. Wong wrote:
> In ext4_file_open, the filesystem records the mountpoint of the first file that
> is opened after mounting the filesystem.  It does this by allocating a 64-byte
> stack buffer, calling d_path() to grab the mount point through which this file
> was accessed, and then memcpy()ing 64 bytes into the superblock's
> s_last_mounted field, starting from the return value of d_path(), which is
> stored as "cp".  However, if cp > buf (which it frequently is since path
> components are prepended starting at the end of buf) then we can end up copying
> stack data into the superblock.
> 
> Writing stack variables into the superblock doesn't sound like a great idea, so
> use strlcpy instead.  Andi Kleen suggested using strlcpy instead of strncpy.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

						- Ted
