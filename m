Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0F2XaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0F2XaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:30:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100629224844.GF4150@mail.oracle.com>
References: <20100629224844.GF4150@mail.oracle.com> <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <20100629200315.23196.68742.stgit@warthog.procyon.org.uk> <26026.1277851016@redhat.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: dhowells@redhat.com, Ulrich Drepper <drepper@gmail.com>,
       viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available
Date: Wed, 30 Jun 2010 00:29:52 +0100
Message-ID: <32322.1277854192@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker <Joel.Becker@oracle.com> wrote:

> 	The less variable length stuff the better, I think.  At least,
> for the stuff stat(2) already returns, you should have a fixed-size
> structure.  Even if I only pass the GIVE_ME_UIDS flag, I don't want to
> have to deal with the variable size stuff until I've actually asked for
> esoteric things.  I'll know that the non-UIDS fields are garbage by the
> fact that I didn't ask for them.

I was thinking of the fixed length xstat struct plus appendable extensions to
be defined later.

I could live with each defined extension being of a fixed length, so for
example, you set bit 20, and it adds, say, a 16-byte volume ID in the
appropriate order, padded out appropriately for the filesystem.

David
