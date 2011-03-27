Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1C0I2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 04:28:47 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39094 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1C0I2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 04:28:43 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 3/5] 9p: revert tsyncfs related changes
In-Reply-To: <4D8D0704.7080106@linux.vnet.ibm.com>
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1301052651-21440-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4D8D0704.7080106@linux.vnet.ibm.com>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Sun, 27 Mar 2011 13:58:33 +0530
Message-ID: <877hbl0xxq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011 14:20:04 -0700, Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com> wrote:
> On 03/25/2011 04:30 AM, Aneesh Kumar K.V wrote:
> > Now that we use write_inode to flush server
> > cache related to fid, we don't need tsyncfs.
> > This help us to do a more efficient server flush
> > for dotu protocol
> Why are you singling out dotu only? won't it be applicable to dotl too?
> 

With dotl we can have new operations and so we added tsyncfs. The
primary goal is to add an operation that can flush server cache. We
hooked that to sync(2) on the client. With dotu we cannot add new
operations so we always forced the write on the server in case of dotu
to O_SYNC. That is much slower than doing an fsync on write_inode. But
whether doing an fsync on write inode is better than doing tsyncfs on
sync(2) on client is something i haven't yet measured. Stefan Hajnoczi wants to
see some numbers before we push tsyncfs in the server(qemu). We also don't
want a kernel release with 9p operation which we may remove later. So
the plan now is to get write_inode changes upstream in this merge window
and later get numbers against tsyncfs/write_inode -> fsync and add tsyncfs only
if we see a benefit. BTW NFS use the write_inode approach.

-aneesh
