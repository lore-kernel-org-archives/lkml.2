Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab0FJSMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:12:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38275 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab0FJSMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:12:21 -0400
Date: Thu, 10 Jun 2010 11:11:58 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       mfasheh@suse.com
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100610181158.GA5934@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
	mfasheh@suse.com
References: <20100610044234.GD26335@laptop>
 <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
 <20100610082711.GA2173@lst.de>
 <20100610084707.GG30672@mail.oracle.com>
 <4C10D600.60209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C10D600.60209@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4C112AF8.006D:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 08:09:36PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >	Is your concern that the u/gid checks may be against stale ids?
> So I think we should have one inode_change_ok before the cluster
> lock and another after the cluster lock.
> The first one will save us a lot of cluster lock effort if the user
> pass us the wrong arguments while the later
> one will test again with the refreshed inode info.

	But what if the other node has given us permission, and then we
fail?  Say the file was owned by you.  On node 2, root sets it to be
owned by me.  Then on node 1, I go to change the file permissions.
inode_change_ok() will fail, because the in-memory inode still thinks
you are the owner.
	I guess it does need to be under the lock.

Joel

-- 

Bram's Law:
	The easier a piece of software is to write, the worse it's
	implemented in practice.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
