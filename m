Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2AaADW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:03:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab2AaADU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:03:20 -0500
Date: Tue, 31 Jan 2012 01:03:19 +0100
From: Jan Kara <jack@suse.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jan Kara <jack@suse.cz>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20120131000319.GH7827@quack.suse.cz>
References: <201201281445.49377.rjw@sisk.pl>
 <20120130200040.GB7827@quack.suse.cz>
 <201201302205.34159.rjw@sisk.pl>
 <4F27074D.2040006@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F27074D.2040006@tuxonice.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 31-01-12 08:10:37, Nigel Cunningham wrote:
> Hi.
> 
> On 31/01/12 08:05, Rafael J. Wysocki wrote:
> > On Monday, January 30, 2012, Jan Kara wrote:
> >> On Sat 28-01-12 14:45:49, Rafael J. Wysocki wrote:
> >>> +	/*
> >>> +	 * Freeze in reverse order so filesystems depending on others are
> >>> +	 * frozen in the right order (eg. loopback on ext3).
> >>> +	 */
> >>   Ho, hum, are you sure the order in super_blocks list is the one you need?
> >> Maybe it is but I'm not sure you are guaranteed it is.
> > 
> > Well, is there any way I can get the right order?
> 
> Jan, what's the case where the reverse of mount order might be the wrong
> order?
  After some though, I'm not able to come up with a counterexample. As I
wrote to Rafael, let's at least document that we rely on some ordering of
super_blocks list.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
