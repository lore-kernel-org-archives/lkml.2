Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0DIPVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:21:51 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54395 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0DIPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=Q0eBe3Gg1kflyYJUT8z/Yo9q23m7+84eQlCDsSNk3uUNsFMoAnQXuCON/hT2W7ywmB
         umcAe7X5CJvzbBL9UdzWbrV4Uv0ZdL0ovQauVOc/QIpqZmOTAA+qvGsDM+XHRL7EQ25/
         w44nvehr+0LWg07WuneXG4o4tUka19qvW5cds=
Message-ID: <4bbf460b.8507cc0a.770b.574d@mx.google.com>
Date: Fri, 09 Apr 2010 08:21:47 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
In-Reply-To: <20100317093704.GA17146@elte.hu>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<20100317045350.GA2869@laptop> <20100317093704.GA17146@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 10:37:04 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Hi,
> > 
> > On Tue, Mar 16, 2010 at 08:31:12AM -0700, Ben Gamari wrote:
> > > Hey all,
> > > 
> > > Recently I started using the Xapian-based notmuch mail client for everyday
> > > use.  One of the things I was quite surprised by after the switch was the
> > > incredible hit in interactive performance that is observed during database
> > > updates. Things are particularly bad during runs of 'notmuch new,' which scans
> > > the file system looking for new messages and adds them to the database.
> > > Specifically, the worst of the performance hit appears to occur when the
> > > database is being updated.
> > > 
> > > During these periods, even small chunks of I/O can become minute-long ordeals.
> > > It is common for latencytop to show 30 second long latencies for page faults
> > > and writing pages.  Interactive performance is absolutely abysmal, with other
> > > unrelated processes feeling horrible latencies, causing media players,
> > > editors, and even terminals to grind to a halt.
> > > 
> > > Despite the system being clearly I/O bound, iostat shows pitiful disk
> > > throughput (700kByte/second read, 300 kByte/second write). Certainly this poor
> > > performance can, at least to some degree, be attributable to the fact that
> > > Xapian uses fdatasync() to ensure data consistency. That being said, it seems
> > > like Xapian's page usage causes horrible thrashing, hence the performance hit
> > > on unrelated processes.
> > 
> > Where are the unrelated processes waiting? Can you get a sample of several 
> > backtraces?  (/proc/<pid>/stack should do it)
> 
> A call-graph profile will show the precise reason for IO latencies, and their 
> relatively likelihood.
> 
Are these backtraces at all useful? I've received no feedback thusfar, so I can
only that either,
  a) there is insufficient data to draw any conclusions and there is no
     interest in pursuing this further, or
  b) nobody has looked at the backtraces

As I've said in the past, I am very interested in seeing this problem looked at and
would love to contribute whatever I can to that effort. However, without knowing what
information is necessary, I can be of only very limited use in my own debugging
efforts. Thanks,

- Ben

