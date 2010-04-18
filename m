Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab0DRT73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:59:29 -0400
Received: from mx2.netapp.com ([216.240.18.37]:54008 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab0DRT71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:59:27 -0400
X-IronPort-AV: E=Sophos;i="4.52,232,1270450800"; 
   d="scan'208";a="346383487"
Subject: Re: 2.6.34rc4 NFS writeback regression (bisected): client often
 fails to delete things it just created
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <87vdboa7e0.fsf@spindle.srvr.nix>
References: <87tyr9dfvv.fsf@spindle.srvr.nix>
	 <1271618484.8049.1.camel@localhost.localdomain>
	 <87vdboa7e0.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Sun, 18 Apr 2010 15:59:10 -0400
Message-ID: <1271620750.8049.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
X-OriginalArrivalTime: 18 Apr 2010 19:59:11.0364 (UTC) FILETIME=[9CFC1C40:01CADF31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-18 at 20:27 +0100, Nix wrote: 
> On 18 Apr 2010, Trond Myklebust verbalised:
> 
> > On Sat, 2010-04-17 at 20:43 +0100, Nix wrote: 
> >> I suspect that unlink()ing a not otherwise open file for which writeback
> >> is still underway is causing the files to be sillyrenamed because
> >> writeback is holding them open. If writeback is the only user, they
> >> should surely not be held open: nobody cares what their contents are,
> >> and a lot of code depends on rm -r of directories containing recently-
> >> written-but-still-closed files succeeding.
> >
> > Did you test with commit b80c3cb628f0ebc241b02e38dd028969fb8026a2 (NFS:
> > Ensure that writeback_single_inode() calls write_inode() when syncing)?
> > That fixed the above problem on my setup.
> 
> tip-of-tree includes that commit, and it's still happening for me there.
> (Just verified again.)

Does a 'sync' clear out the sillyrenamed files?

> (The exported filesystem is coming from a box running 2.6.33 atop ext4,
> in case it matters.)

That shouldn't matter.
