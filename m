Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1JRVOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:14:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1JRVOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:14:48 -0400
Date: Tue, 18 Oct 2011 23:14:46 +0200
From: Jan Kara <jack@suse.cz>
To: Mark Mielke <mark@mark.mielke.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Appropriate use of sync() from user space?
Message-ID: <20111018211446.GF4599@quack.suse.cz>
References: <4E8CEECF.4050008@mark.mielke.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8CEECF.4050008@mark.mielke.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Wed 05-10-11 19:57:03, Mark Mielke wrote:
> Quick summary: We have a vendor who is claiming that it is required
> for their userspace program to execute sync(), and I am looking for
> some sort of authoritative document or person to refer them to that
> will state that this belief is incorrect and/or that this
> architecture is not acceptable in a Unix environment.
> 
> I checked Google and the archives and didn't find anything
> appropriate. Unfortunately, the word "sync" is very popular. :-)
> 
> We have users who have been experiencing 3 to 5 minutes "freezes"
> for a particular command which often times out and fails. I traced
> this down from the commercial userspace program (IBM Rational
> ClearCase / "cleartool mkview") that they are executing to a backend
> "view_server" process (also IBM Rational ClearCase) that is running
> sync() as a means of synchronizing their database to disk before
> proceeding, and VMware using a "large" memory mapped file to back
> it's virtual "RAM". The sync() for my computer normally completes in
> 7 to 8 seconds. The sync() for some of our users is taking 5 minutes
> or longer. This can be demonstrated simply by typing "time sync"
> from the command line at intervals. The time itself is relevant
> because if it finishes before a timeout elapses - the operation
> works (albeit slowly). If the timeout elapses, the operation fails.
> 
> The vendor stated that sync() is integral to their synchronization
> process to ensure all files reach disk before they are accessed, and
> that this is not a defect in their product. We have a work around -
> run "sync" before calling their command, and this generally avoids
> the failures.
> 
> I think the use of sync() in this regard is a hack. According to
> POSIX.1 and the Linux man pages, it seems clear to me that sync()
> does not guarantee data integrity (bytes guaranteed to have reached
> disk) - and it also seems clear that forcing all system data to
> flush out in response to a minor command is over kill. Like cutting
> down the forest to harvest fruit from a single tree.
  Actually the manpage is wrong. Linux waits for all data to be safely on
disk before sync returns. So calling sync is a correct way (although
inefficient at times) to achieve data integrity. What kernel version are
you using? Different kernel versions are differently efficient when doing
sync(2) and quite some effort went to make sync less prone to livelocks in
recent kernels...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
