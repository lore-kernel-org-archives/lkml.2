Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0HTOi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:38:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50159 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab0HTOi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:38:57 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
In-Reply-To: <20100820083057.GA10039@infradead.org>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083057.GA10039@infradead.org>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 20 Aug 2010 20:08:41 +0530
Message-ID: <m3bp8xs61a.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 04:30:57 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> Suddenly getting an file pointer for a symlink which could never happen
> before is a really bad idea.  Just add a proper readlink_by_handle
> system call, similar to what's done in the XFS interface.

It is not just readlink that we would need. We would require

   sys_handle_readlink, sys_handle_stat64, sys_handle_link, sys_handle_chown,
   sys_handle_setxattr, sys_handle_getxattr, sys_handle_listxattr,
   sys_handle_removexattr, sys_handle_utimes, compat_sys_handle_utimes

I have most of the changes done, so if we are ok adding all these
new syscalls i can post the patch series.

-aneesh

