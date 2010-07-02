Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab0GBPt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 11:49:58 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16949 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0GBPty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 11:49:54 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=oACb-Ty_HC0A:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=2Yc41jHLyiBWyj_teXQA:9
 a=hESbSC559WZH6eRWmnoeAnA0MeUA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com>
Date: Fri, 2 Jul 2010 09:49:52 -0600
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
       linux-api@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2DBA0FC9-192C-49F2-8DB5-F33090B1C221@dilger.ca>
References: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk> <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-01, at 23:36, Michael Kerrisk wrote:
> * Include information from the "inode_info" structure, most notably
> i_flags, but perhaps other info as well.

This one is actually pretty interesting, though instead of exporting the i_flags directly (the S_* flags), it would be much better to export the FS_*_FL values.  The FS_*_FL values (e.g. FS_IMMUTABLE_FL) are already exposed to userspace via FS_IOC_{GET,SET}FLAGS and are stored on disk in ext2/3/4, so are guaranteed never to change.  The S_* flags DO in fact change between kernel releases.


Cheers, Andreas





