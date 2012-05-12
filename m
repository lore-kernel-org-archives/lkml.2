Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2ELLm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 07:42:57 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43781 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab2ELLmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 07:42:54 -0400
Message-ID: <4FAE4C70.5000804@parallels.com>
Date: Sat, 12 May 2012 15:41:36 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH] vfs: Add setns support for the mount namespace
References: <4FAD0524.3000307@parallels.com> <4FAD0555.4090906@parallels.com> <87mx5e5tho.fsf_-_@xmission.com>
In-Reply-To: <87mx5e5tho.fsf_-_@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 12:54 AM, Eric W. Biederman wrote:
> 
> setns support for the mount namespace is a little tricky as an arbitrary
> decision must be made about what to set fs->root and fs->pwd to, as
> there is no expectation of a relationship between the two mount
> namespaces.  Therefore I arbitrarily find the root mount point, and
> follow every mount on top of it to find the top of the mount stack.
> Then I set fs->root and fs->pwd to that location.  The topmost root of
> the mount stack seems like a reasonable place to be.
> 
> Bind mount support for the mount namespace inodes has the possibility of
> creating circular dependencies between mount namespaces.  Circular
> dependencies can result in loops that prevent mount namespaces from
> every being freed.  I avoid creating those circular dependencies by
> adding a sequence number to the mount namespace and require all bind
> mounts be of a younger mount namespace into an older mount namespace.
> 
> Add a helper function proc_ns_inode so it is possible to detect when we
> are attempting to bind mound a namespace inode.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
