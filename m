Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2ADTlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:41:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53283 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751798Ab2ADTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:41:13 -0500
Date: Wed, 4 Jan 2012 14:41:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Sysfs attributes racing with unregistration
In-Reply-To: <m1d3azfiab.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.1201041431160.1505-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, Eric W. Biederman wrote:

> > Someone (I think Eric, right?) was trying to generalize the semantics
> > to vfs layer so that severance/revocation capability is generally
> > available.  IIRC, it didn't get through tho.
> 
> Unfortunately I didn't have time to complete the effort of those
> patches.  The approach was not fundamentally rejected but it needed a
> clear and convincing use case as well as some strong scrutiny.  But
> fundamentally finding a way to do that was seen as an interesting,
> if it could be solved without slowing down the existing cases.

Ted Ts'o has been talking about something similar but not the same -- a
way to revoke an entire filesystem.  For example, see commit
7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
kludge to avoid an oops after the disk disappears).

The use case for that is obvious and widespread: Somebody yanks out a
USB drive without unmounting it first.

Alan Stern

