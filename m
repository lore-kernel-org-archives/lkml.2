Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab1DHQUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:20:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59290 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1DHQUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r+nzlZ43KK3WUvdIZLPQNbxkDx0czgNSHvA0a52FfsmnNwGmwG8I7lKJHchJeLvBKe
         AOaxR0iOG/kswf5TxaRpveTv5DqkPMBz9doFrOPcsz4rl2a03Bm+q9SY3XHT8cZpu6FL
         cdb/leKJCdNgdGkz4YtWWdXsp5ITDVW4Hb9ok=
Date: Fri, 8 Apr 2011 09:20:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Message-ID: <20110408162041.GB3871@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
 <20110405065129.GC2872@amit-x200.redhat.com>
 <20110406100620.GA4142@mtj.dyndns.org>
 <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 08, 2011 at 12:37:56PM +0100, Stefan Hajnoczi wrote:
> There is a related issue I have been discussing with Amit:
> https://lkml.org/lkml/2011/3/23/156
> 
> On media change the inode size is not updated by the sr driver or the
> universal cdrom driver.  A userspace process that holds a /dev/sr0
> file descriptor open across media change causes all processes on the
> system to see the old medium size when they do lseek(fd, 0, SEEK_END).
> 
> I think it would make sense to refresh the inode size on media change
> so that even open file descriptors see the new size and a single
> process cannot force a stale value for all other userspace processes
> on the system.

Hmmm... I don't know.  Maybe we can but I'm not sure whether there's a
good reason for it.  cdrom is locked while opened after all.  Are
there actual problems?

Thanks.

-- 
tejun
