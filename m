Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0E1Tr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:47:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42333 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab0E1Try (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:47:54 -0400
Date: Fri, 28 May 2010 20:47:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile, part 2
Message-ID: <20100528194753.GL31073@ZenIV.linux.org.uk>
References: <20100528155102.GK31073@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.1005281221090.27944@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005281221090.27944@cobra.newdream.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 12:27:51PM -0700, Sage Weil wrote:
> Hi Al,
> 
> There are two patches
> 
>  1f24668c vfs: make real_lookup do dentry revalidation with i_mutex held
>  982ddae4 vfs: clean up do_lookup()
> 
> that were in your for-next a few weeks back but aren't anymore (they're 
> still in your autofs branch).  I just want to make sure those don't get 
> lost if they're not going to make it upstream this time around?  I think 
> they've been in vfs-2.6.git limbo for two release cycles now.

My apologies, I thought you'd been Cc'd on the discussions with Ian concerning
that stuff, but...

The bottom line: "autofs4: always use lookup for lookup" is needed for them
and it had to be reverted since it'd been FUBAR.

Details: we really, *really* can not do things in ->d_revalidate() and count
on ->lookup() to come and finish them.  Think for a minute and you'll see why -
between these two calls we allocate a dentry to pass to ->lookup().  What
happens if that allocation fails?

And without that patch your stuff breaks autofs4.  So it's waiting for the
->d_revalidate() interface redesign.  Hopefully in the coming cycle...
