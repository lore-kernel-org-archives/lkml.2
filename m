Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2HQNkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:40:47 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45241 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2HQNkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:40:42 -0400
Date: Fri, 17 Aug 2012 09:40:39 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Marti Raudsepp <marti@juffo.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
        "Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
Subject: Re: ext4 write performance regression in 3.6-rc1
Message-ID: <20120817134039.GB11439@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817060915.GB28786@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 02:09:15PM +0800, Fengguang Wu wrote:
> Ted,
> 
> I find ext4 write performance dropped by 3.3% on average in the
> 3.6-rc1 merge window. xfs and btrfs are fine.
> 
> Two machines are tested. The performance regression happens in the
> lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
> not see regression, which is equipped with HDD drives. I'll continue
> to repeat the tests and report variations.

Hmm... I've checked out the commits in "git log v3.5..v3.6-rc1 --
fs/ext4 fs/jbd2" and I don't see anything that I would expect would
cause that.  The are the lock elimination changes for Direct I/O
overwrites, but that shouldn't matter for your tests which are
measuring buffered writes, correct?

Is there any chance you could do me a favor and do a git bisect
restricted to commits involving fs/ext4 and fs/jbd2?

Many thanks,

						- Ted
