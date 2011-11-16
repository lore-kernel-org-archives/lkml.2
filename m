Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1KPXWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:22:38 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39911 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1KPXWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:22:37 -0500
Subject: Re: [Patch] tmpfs: add fallocate support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        Lennart Poettering <lennart@poettering.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <4EC36494.30803@redhat.com>
References: <1321346525-10187-1-git-send-email-amwang@redhat.com>
	 <4EC23DB0.3020306@redhat.com> <1321379039.12374.11.camel@nimitz>
	 <4EC36494.30803@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 15:21:55 -0800
Message-ID: <1321485715.12374.56.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
x-cbid: 11111623-8974-0000-0000-000002433F80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 15:21 +0800, Cong Wang wrote:
> 于 2011年11月16日 01:43, Dave Hansen 写道:
> > On Tue, 2011-11-15 at 18:23 +0800, Cong Wang wrote:
> >>> +	if (!(mode&   FALLOC_FL_KEEP_SIZE)) {
> >>> +		ret = inode_newsize_ok(inode, (offset + len));
> >>> +		if (ret)
> >>> +			return ret;
> >>> +	}
> >
> > inode_newsize_ok()'s comments say:
> >
> >   * inode_newsize_ok must be called with i_mutex held.
> >
> > But I don't see any trace of it.
> 
> Hmm, even for tmpfs? I see none of the tmpfs code takes
> i_mutex lock though...

Look harder. :)

ramfs/tmpfs for a large part just used the generic VFS functions to do
their work since they're page-cache based.  For instance:

static const struct file_operations shmem_file_operations = {
...
        .aio_write      = generic_file_aio_write,

IOW, you need to check beyond mm/shmem.c.

-- Dave

