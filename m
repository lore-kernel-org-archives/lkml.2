Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0ERCkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 22:40:11 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:45564 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0ERCkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 22:40:09 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-Reply-To: <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 18 May 2010 11:33:50 +0900
Message-ID: <7252.1274150030@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"Aneesh Kumar K.V":
> This patch add a new superblock operations get_fsid that returns the
> UUID mapping for the file system. The UUID returned is used to
> identify the file system apart of file_handle

I am afraid get_fsid in s_op may conflict with "fsid=" option in /etc/exports.
Generally all FSs have UUID or device number and they can return "fsid"
correctly. But some of them may not have such id, or users may assign
different fsid for them.
Is "fsid=" value passed to superblock and can FS return it? Otherwise
they cannot implement ->get_fsid().


J. R. Okajima
