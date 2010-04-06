Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0DFPeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:34:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0DFPdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:33:55 -0400
Date: Tue, 6 Apr 2010 17:33:48 +0200
From: Karel Zak <kzak@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Extended partition mapping wrong size
Message-ID: <20100406153348.GE7858@nb.net.home>
References: <4BB0D12B.6060701@cfl.rr.com> <20100406114706.GA30340@nb.net.home> <4BBB3E0F.1030309@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBB3E0F.1030309@cfl.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 09:58:39AM -0400, Phillip Susi wrote:
> On 4/6/2010 7:47 AM, Karel Zak wrote:
> > This is probably kernel bug. It's really insane that the extended
> > pseudo partition overflows to the next logical partition.
> 
> Indeed.
> 
> >  Please no. I think the size should not be more than 2 sectors (1024
> >  bytes). The current concept works for years and we have in userspace 
> >  /etc/partitions parsers that use "if (blocks <= 1)" to detect

Sorry, /proc/partitions

> >  extended partitions.
> 
> Could you elaborate a bit on this?  What programs have such tests and
> what would they do differently if it were larger?

I know about libblkid in e2fsprogs and util-linux-ng. It scans
/proc/partitions to get list of "normal" block devices.

We have no clue how many programs/scripts depend on this behaviour.

> >  The other problem are mkfs programs, the space used for alignment
> >  could be 1MiB (or more) -- it's enough many mkfs programs.
> 
> What's wrong with that? 

Irrelevant question ;-) It's there for years and it's well know kernel
feature. 

I understand that from a pedantic point of view the current solution is
not perfect, but I don't see any practical reason why we need to change
anything. There is no issue. Right?

> If you REALLY want to, there's no reason you can't create a tiny fs there. 

You have to care about the partition table (EBR).

The current 1024 bytes is completely useless size, if you enlarge the
size of the partition (for example to 1MiB) you will see reports from
people who lost their extended partitions. (I don't believe that all
mkfs programs are able to detect/skip EBR.)

> Then again, I could swear that once upon a time the kernel simply
> did not bother creating a dev node for the extended partition, and
> this seems to be a hack that was put in to make it easy for LILO to
> install to one.  Personally I'd prefer going back to the old
> behavior of just not having a useless device there.

This is probably better idea than enlarge the size :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
