Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1E1One (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:43:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:29321 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab1E1Ond (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:43:33 -0400
X-ExtLoop1: 1
Date: Sat, 28 May 2011 07:43:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 2/4] EXT4: Set NOSEC flag early when there are no xattrs
Message-ID: <20110528144331.GA25561@alboin.amr.corp.intel.com>
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
 <1306536845-24162-2-git-send-email-andi@firstfloor.org>
 <4DE0BB71.9000303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE0BB71.9000303@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 11:08:01AM +0200, Marco Stornelli wrote:
> Il 28/05/2011 00:54, Andi Kleen ha scritto:
> >From: Andi Kleen<ak@linux.intel.com>
> >
> >This avoids a xattr lookup on every write.
> >
> >Cc: tytso@mit.edu
> >Signed-off-by: Andi Kleen<ak@linux.intel.com>
> 
> Are ext2/3 affected too? It seems to me that more or less the xattr
> management for the extN series is the same, isn't it?

Yes, they could be changed the same way.

Note however that the file system specific change is only a relatively
minor optimization (avoids the first lookup). The important one is
the cache which every file system get's automatically without changes.

-Andi
