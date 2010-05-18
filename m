Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0ERG6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:58:34 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55534 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab0ERG6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:58:31 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
In-Reply-To: <10947.1274163508@jrobl>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl> <87fx1ppy21.fsf@linux.vnet.ibm.com> <10947.1274163508@jrobl>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 18 May 2010 12:28:20 +0530
Message-ID: <87aarxpugj.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 15:18:28 +0900, "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> 
> "Aneesh Kumar K. V":
> > The file_handle I mentioned above is the file handle returned by
> > sys_name_to_handle_at syscall. NFS kernel server won't be using the
> > interface.
> 
> Thanx clarifying.
> I think I should read the notes in the first description (0/9) before
> posting.
> It says UUID is just for userspace.
> 
> Reading all 9 patches, I noticed handle_to_path() calls
> exportfs_decode_fh() inconditionally.
> Since exportfs_decode_fh() calls s_export_op->fh_to_dentry()
> inconditionally too, handle_to_path() will crash when the target FS
> doesn't support NFS-exporting, won't it?
> 

I guess we should fix exprtfs_decode_fh to return -ESTALE if
fh_to_dentry is NULL

-aneesh
