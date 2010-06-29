Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0F2SN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:13:58 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:46815 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0F2SN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:13:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=o9CK1RTiBG0A:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=81fKdhF2Zd8y9jJC7oIA:9
 a=qNmrfnJqmYCbbJ0rRCQA:7 a=N8pNo9sonwGIHLFp9IK5AMTo8koA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation	available by xattrs
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <AANLkTikhZn15GmOTe-fsM2IgxHFxtZIRBOb_4kPWSR4E@mail.gmail.com>
Date: Tue, 29 Jun 2010 12:13:54 -0600
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E7B61059-6CF2-4269-A1E7-E398F7B97CCF@dilger.ca>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca> <8831.1277753903@redhat.com> <AANLkTikhZn15GmOTe-fsM2IgxHFxtZIRBOb_4kPWSR4E@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-28, at 13:41, Steve French wrote:
> I think backing them up makes sense, even if they can't easily
> be restored (ie just for reporting).

Right.  I think being able to restore the crtime (as root) makes sense, I don't think restoring i_generation and i_version make sense however, given that we can't preserve the inode number.  The filesystem can silently ignore them when they are written as xattrs (returning an error gives "tar" and "cp" heartburn, we've found).

> Are there security differences between the "trusted" namespace that
> would make it harder for an app to read them (the man page did not list
> the security differences between trusted and user xattrs).

"trusted." is only writeable by root and the kernel.  "user." is writeable by regular users.

Cheers, Andreas





