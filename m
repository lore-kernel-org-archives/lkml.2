Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab1IIKDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:03:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab1IIKDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:03:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1315243548-18664-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1315243548-18664-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, agruen@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 08/26] vfs: Add new file and directory create permission flags
Date: Fri, 09 Sep 2011 11:02:58 +0100
Message-ID: <22786.1315562578@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:

> -static inline int may_create(struct inode *dir, struct dentry *child)
> +static inline int may_create(struct inode *dir, struct dentry *child, int isdir)

Would it make sense to pass the proposed mode_t instead?  That way you can
check for symlinks and other file types too if necessary later.

David
