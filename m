Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0IGP6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:58:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56823 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0IGP6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:58:37 -0400
Subject: Re: [PATCH 09/10] VFS: Remove read-only checks from
 dentry_permission
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: NeilBrown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100906005029.20775.70918.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
	 <20100906005029.20775.70918.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 07 Sep 2010 08:58:34 -0700
Message-ID: <1283875114.7586.3618.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 10:50 +1000, NeilBrown wrote:
> It is not sufficient to depend on the the "filesystem is readonly"
> tests in dentry_permission as it does not check if the vfsmnt is
> readonly.
> All call sites already call mnt_want_write or __mnt_is_readonly which
> includes the test on MS_RDONLY.
> 
> So remove this test from dentry_permission as it simply duplicates
> tests done elsewhere.

Yeah, I remember auditing all of the dentry_permission() callers and
moving them over to mnt_want_write() and friends as well.  I don't quite
remember why we didn't take this step back then, but it looks sane to
me.

-- Dave

