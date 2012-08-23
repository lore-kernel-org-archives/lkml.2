Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab2HWMXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:23:45 -0400
Received: from fieldses.org ([174.143.236.118]:36213 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab2HWMXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:23:20 -0400
Date: Thu, 23 Aug 2012 08:23:18 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 0/9] extended fdinfo via procfs series, v7
Message-ID: <20120823122318.GD29943@fieldses.org>
References: <20120823104323.040550004@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823104323.040550004@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:43:23PM +0400, Cyrill Gorcunov wrote:
> Hi guys,
> 
> here is updated version of the fdinfo via procfs series,
> the changes from previous one are the following
> 
>  - fhandle is carried inside inotify mark but this feature
>    is CONFIG dependent to not bloat the kernel for users
>    who don't need it

As Al points out, this doesn't help much: if this feature is something a
distro will want to provide, then in practice all their users are
eventually going to end up with it turned on.

Could you quantify the cost somehow?

I wonder if you could get away with something less than MAX_HANDLE_SIZE?
128 bytes is the maximum allowable by NFSv4.  In practice I don't think
any of our filesystems need more than 40 or so right now.

--b.

> 
>  - a small fix in exportfs code to prevent nil dereference
> 
> the comments would be appreciated.
