Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2HFOnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:43:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36547 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754782Ab2HFOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:42:59 -0400
Date: Mon, 6 Aug 2012 10:42:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
cc: Todd Poynor <toddpoynor@google.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <arve@android.com>
Subject: Re: [PATCH v2] PM / Sleep: Print name of wakeup source that aborts
 suspend
In-Reply-To: <201208061315.13302.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208061037110.1649-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Rafael J. Wysocki wrote:

> On Monday, August 06, 2012, Alan Stern wrote:
> > On Sun, 5 Aug 2012, Rafael J. Wysocki wrote:
> > 
> > > > v2
> > > > use ktime_to_ns() instead of comparisons on .tv64 field
> > 
> > What is the reason for this?  It apparently adds complexity and code 
> > (on non-64-bit systems) to no purpose.
> 
> I don't think accessing the internals of ktime_t is appropriate,
> even though avoiding that may result in some computational cost.

I asked this question because I recently added some code that does the
very same thing, using the .tv64 field instead of doing any
conversions.

Thomas, is there any general advice on how to compare two ktime_t
values?  Is it acceptable for general code to use the .tv64 field for
this?  The comments in ktime.h say that the encoding was chosen partly
for this very reason.

Alan Stern

