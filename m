Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1CRS57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:57:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab1CRS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:57:54 -0400
Date: Fri, 18 Mar 2011 18:57:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: pstore: fix leaking ->i_private
Message-ID: <20110318185750.GM22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
 <4d83a82032021e2997@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d83a82032021e2997@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 11:44:48AM -0700, Luck, Tony wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> Move kfree() of i_private out of ->unlink() and into ->evict_inode()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Applied (with one trivial change - in your case it doesn't matter, but
people do copy from weird places and conceptually you want to get VFS
end any async activity on inode before starting to tear it apart, so
end_writeback() should normally go first).
