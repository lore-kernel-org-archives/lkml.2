Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab0HTCNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:13:35 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48272 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0HTCNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:13:21 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
In-Reply-To: <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 20 Aug 2010 07:43:12 +0530
Message-ID: <m3fwya8213.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 07:21:28 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> The patch update may_open to allow handle based open on symlinks.
> The file handle based API use file descritor returned from open_by_handle_at
> to do different file system operations. To find the link target name we
> need to get a file descriptor on symlinks.
> 
> We should be able to read the link target using file handle. The exact
> usecase is with respect to implementing READLINK operation on a
> userspace NFS server. The request contain the file handle and the
> response include target name.
> 

If we don't do this, we will need new syscalls for doing stat, readlink
and link on symlinks that take file handle as the argument. If that is ok,
I can redo the patch series accordingly.

-aneesh
