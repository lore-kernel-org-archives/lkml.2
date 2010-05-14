Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0ENUXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:23:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51074 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0ENUXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:23:32 -0400
Date: Fri, 14 May 2010 21:23:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH] anon_inode: set S_IFREG on the anon_inode
Message-ID: <20100514202329.GX30031@ZenIV.linux.org.uk>
References: <20100514200555.17387.92658.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514200555.17387.92658.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 04:05:59PM -0400, Eric Paris wrote:
> anon_inode_mkinode() sets inode->i_mode = S_IRUSR | S_IWUSR;  This means
> that (inode->i_mode & S_IFMT) == 0.  This trips up some SELinux code that
> needs to determine if a given inode is a regular file, a directory, etc.
> The easiest solution is to just make sure that the anon_inode also sets
> S_IFREG.

How urgent that one is?  It is obvious enough, so I could include it into
the pull request for -final, but...
