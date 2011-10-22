Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1JVQcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 12:32:00 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41808 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753794Ab1JVQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 12:31:58 -0400
Date: Sat, 22 Oct 2011 12:31:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
In-Reply-To: <Pine.LNX.4.44L0.1110212125020.8657-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1110221223480.20346-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, Alan Stern wrote:

> > Maybe we could do something with futexes...
> 
> Not easily -- as far as I can tell, futexes enjoy relatively little 
> support.  In any case, they provide the same service as a mutex, which 
> means you'd have to build a shared lock on top of them.

It occurred to me that we could create a new type of special file, one
intended to help with interprocess synchronization.  It would support
locking (shared or exclusive, blocking or non-blocking) and the poll
system call -- the file would appear to be ready for reading whenever a
shared lock wouldn't block and ready for writing whenever an exclusive
lock wouldn't block.  Actual reads and writes wouldn't have to do 
anything, although maybe someone could suggest a use for them.

Alan Stern

