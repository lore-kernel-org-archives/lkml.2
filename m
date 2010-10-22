Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0JVGqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 02:46:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35689 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0JVGqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 02:46:39 -0400
Date: Fri, 22 Oct 2010 07:46:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] vfs: protect remounting superblock read-only
Message-ID: <20101022064627.GA21607@ZenIV.linux.org.uk>
References: <20101005103108.288743609@szeredi.hu>
 <20101005103144.051231469@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005103144.051231469@szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 12:31:15PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Currently remouting superblock read-only is racy in a major way.
> 
> With the per mount read-only infrastructure it is now possible to
> prevent most races, which this patch attempts.
> 
> Before starting the remount read-only, set MNT_WRITE_HOLD on all
> mounts so that writes are held off until the remount either succeeds
> or fails.

Umm...  What'll happen if your remount will say mnt_want_write() on
e.g. internal vfsmount over that sb?  Or, more subtle, tries to
update atime on some opened struct file on that sb.
