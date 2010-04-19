Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0DSPdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0DSPdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:33:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Trond.Myklebust@netapp.com, paulmck@linux.vnet.ibm.com
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: RCU-isms in fs/nfs/delegation.c
Date: Mon, 19 Apr 2010 16:33:05 +0100
Message-ID: <14317.1271691185@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm trying to redo my NFS RCU warning fixup patch on top of Paul's patches,
and I've found a small potential bug: nfs_inode_reclaim_delegation() doesn't
use the appropriate accessors/locks to protect NFS_I(inode)->delegation, and
nor does it use such to protect *delegation that I can see.  It just
overwrites the record.

Furthermore, for consistency's sake, it should also protect accesses to
delegation->cred within that function.

Trond: can you confirm that both NFS_I(inode)->delegation and delegation->cred
should be considered RCU-protected pointers?

David
