Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0ERGTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:19:43 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:37346 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0ERGTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:19:42 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-Reply-To: <87fx1ppy21.fsf@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl> <87fx1ppy21.fsf@linux.vnet.ibm.com>
Date: Tue, 18 May 2010 15:18:28 +0900
Message-ID: <10947.1274163508@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"Aneesh Kumar K. V":
> The file_handle I mentioned above is the file handle returned by
> sys_name_to_handle_at syscall. NFS kernel server won't be using the
> interface.

Thanx clarifying.
I think I should read the notes in the first description (0/9) before
posting.
It says UUID is just for userspace.

Reading all 9 patches, I noticed handle_to_path() calls
exportfs_decode_fh() inconditionally.
Since exportfs_decode_fh() calls s_export_op->fh_to_dentry()
inconditionally too, handle_to_path() will crash when the target FS
doesn't support NFS-exporting, won't it?


J. R. Okajima
