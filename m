Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab2CSEji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:39:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48454 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2CSEjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:39:37 -0400
Date: Mon, 19 Mar 2012 00:39:37 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Daney <david.daney@cavium.com>
Cc: Joe Perches <joe@perches.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] ext4: Add -DDEBUG to Makefile
Message-ID: <20120319043937.GN31682@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Daney <david.daney@cavium.com>, Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1331856299.git.joe@perches.com>
 <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com>
 <4F63646D.1040700@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F63646D.1040700@cavium.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 09:03:57AM -0700, David Daney wrote:
> 
> In many other susbsystems/drivers, the definition of DEBUG is gated
> by a separate Kconfig symbol used to select debugging just for that
> susbsystem/driver (see CONFIG_MMC_DEBUG for example).

In ext4 we have many different debugging patches, and in general you'd
never want to enable them all at once (you'd get way too much noise).
The debugging statements are there when a developer is debugging very
specific section of code (i.e., the directory index, or the extent
tree, or the block allocator, etc.).  It's really only ext4 developers
who need to use those debugging statements, and even for them it's
quite rare.

So I've never considered it worthwhile to enable them via a CONFIG_*
menu item; developers who are debugging a specific problem will
generally just drop in the specific #define on an ad hoc basis, and
that works fine.

					- Ted
