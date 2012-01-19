Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2ASPNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:13:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46142 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753091Ab2ASPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:13:21 -0500
Date: Thu, 19 Jan 2012 10:13:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
        "Luck, Tony" <tony.luck@intel.com>, Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
In-Reply-To: <4F181ACF.20505@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1201191007541.1447-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, Srivatsa S. Bhat wrote:

> On 01/19/2012 06:02 PM, Ingo Molnar wrote:

> > But this is not what happened here - it's a special piece of 
> > fundamental hardware that doesnt hot-plug separately from the 
> > CPU and that has just a single "user".
> > 
> > So i'm curious, why wasn't the memset() enough? It should have 
> > resolved the bug AFAICS.
> > 
> 
> 
>  It did! The memset _did_ fix the bug.

But will it continue to fix the bug in the future?

Or to put it another way, even though no code takes references to these
device structures (can you really guarantee that even now?), how do you
prevent references being taken in future versions of the kernel?  
Calling memset while there still are outstanding references very
definitely _is_ a bug.

IIRC, it used to be completely impossible to prevent this from
happening because sysfs would take references whenever user tasks
opened attribute files.  Sysfs no longer does this, but the basic
principle of defensive programming still applies.

Alan Stern

