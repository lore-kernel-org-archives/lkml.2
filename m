Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab0FRTgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:36:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44138 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0FRTgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:36:49 -0400
Date: Fri, 18 Jun 2010 15:35:55 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Edward Shishkin <edward@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Edward Shishkin <edward.shishkin@gmail.com>, Mat <jackdachef@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       The development of BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal
 fragmentation in Btrfs)
Message-ID: <20100618193555.GV27466@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Edward Shishkin <edward@redhat.com>,
	Jamie Lokier <jamie@shareable.org>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
References: <4C07C321.8010000@redhat.com>
 <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
 <4C1B7560.1000806@gmail.com>
 <20100618155653.GC10919@shareable.org>
 <4C1BC924.30604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1BC924.30604@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C1BCAB4.013E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 09:29:40PM +0200, Edward Shishkin wrote:
> Jamie Lokier wrote:
> >Edward Shishkin wrote:
> >>If you decide to base your file system on some algorithms then please
> >>use the original ones from proper academic papers. DO NOT modify the
> >>algorithms in solitude: this is very fragile thing! All such
> >>modifications must be reviewed by specialists in the theory of
> >>algorithms. Such review can be done in various scientific magazines of
> >>proper level.
> >>
> >>Personally I don't see any way to improve the situation with Btrfs
> >>except full redesigning the last one. If you want to base your file
> >>system on the paper of Ohad Rodeh, then please, use *exactly* the
> >>Bayer's B-trees that he refers to. That said, make sure that all
> >>records you put to the tree has equal length and all non-root nodes of
> >>your tree are at least half filled.
> >
> >First, thanks Edward for identifying a specific problem with the
> >current btrfs implementation.
> 
> Hello Jamie.
> 
> >I've studied modified B-trees quite a lot and know enough to be sure
> >that they are quite robust when you modify them in all sorts of ways.
> 
> Which property is robust?
> 
> >Moreover, you are incorrect to say there's an intrinsic algorithmic
> >problem with variable-length records.  It is not true; if Knuth said
> >so, Knuth was mistaken.
> 
> I didn't say about intrinsic algorithmic problems :)
> I just repeat (after Knuth et al) that B-trees with variable-length
> records don't
> have any sane boundary for internal fragmentation. The common idea
> is that if we
> don't want Btrfs to be in infinite development stage, then we should
> choose some
> *sane* strategy (for example the paper of Ohad Rodeh) and strictly
> adhere this in
> future.

Again, other than the inline file data, what exactly do you believe
needs to change?  Top down balancing vs balancing on insertion doesn't
impact our ability to maintain full leaves.  The current code is clearly
choosing not to merge two leaves that it should have merged, which is
just a plain old bug.

-chris
