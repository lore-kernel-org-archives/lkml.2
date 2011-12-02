Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1LBTmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:42:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58289 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1LBTmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:42:23 -0500
Date: Fri, 2 Dec 2011 20:42:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, fengguang.wu@intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs files
Message-ID: <20111202194219.GU24062@one.firstfloor.org>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org> <1322851407-17182-2-git-send-email-andi@firstfloor.org> <20111202191724.GA13613@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202191724.GA13613@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 11:17:24AM -0800, Greg KH wrote:
> I like this, but some documentation will probably need to be added
> somwhere saying that it's now legal to create a debugfs file with
> "this/is/a/tree" and have it all be expanded out.

Ok. Updating the kerneldoc entries.

> 
> And yes, cleaning up the directories shouldn't be a big issue, but what
> if the directory is already there and it tries to be created again?
> Shouldn't you do a lookup first and use that dentry if it's there?

In this case debugfs_create_dir() errors out, the caller ignores
the error and just looks it up. So yes should work.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
