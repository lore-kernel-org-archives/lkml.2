Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab1IIMql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab1IIMqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:46:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1315243548-18664-26-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1315243548-18664-26-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, agruen@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 25/26] ext4: Implement rich acl for ext4
Date: Fri, 09 Sep 2011 13:45:58 +0100
Message-ID: <25112.1315572358@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:

> +	retval = ext4_set_richacl(handle, inode, acl);
> +	ext4_journal_stop(handle);
> +	if (retval == ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> +		goto retry;

Should that be -ENOSPC?

I do wonder, why does ext4 need to know about richacls at all?  Surely, as far
as ext4 is concerned, they should be seen as xattrs?

If ext4 needs a mark on disk to say it supports richacls, then why can't that
simply be the presence or lack thereof of a richacl on the root dir?

David
