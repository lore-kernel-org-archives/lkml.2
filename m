Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1LBTTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:19:37 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57156 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350Ab1LBTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:19:35 -0500
X-Sasl-enc: KL7p5CUcEJD0SpTctZFCD2NNSKep3//5gxTBBQTq4WsM 1322853574
Date: Fri, 2 Dec 2011 11:17:24 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs
 files
Message-ID: <20111202191724.GA13613@kroah.com>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
 <1322851407-17182-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322851407-17182-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 10:43:25AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Allow passing path names to debugfs_create* and automatically create
> the parents. This makes it much simpler for the caller to create hierarchies.
> 
> The way the reference counts are handled is admittedly a bit ugly.
> 
> There is no way to clean them up currently other than to delete the tree,
> but that doesn't seem like a big problem for debugfs to leave
> behind a few empty directories.

I like this, but some documentation will probably need to be added
somwhere saying that it's now legal to create a debugfs file with
"this/is/a/tree" and have it all be expanded out.

And yes, cleaning up the directories shouldn't be a big issue, but what
if the directory is already there and it tries to be created again?
Shouldn't you do a lookup first and use that dentry if it's there?

thanks,

greg k-h
