Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0E2ULU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 16:11:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56798 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab0E2ULS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 16:11:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Sat, 29 May 2010 22:12:36 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <201005282344.49892.rjw@sisk.pl> <1275119617.27810.12634.camel@twins>
In-Reply-To: <1275119617.27810.12634.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005292212.36107.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 May 2010, Peter Zijlstra wrote:
> On Fri, 2010-05-28 at 23:44 +0200, Rafael J. Wysocki wrote:
> > Consider updatedb or another file indexing ... thing on a laptop.  I certainly
> > don't want anything like this to run and drain my battery, even if it has
> > already been started when the machine was on AC power.  Now, of course,
> > I can kill it, but for that I need to notice that it's running and it presumably
> > might have done some job already and it would be wasteful to lose it.
> > It would be quite nice if that app was not regarded as runnable when the
> > system was on battery power. 
> 
> How will a ionice on steriods that will defer servicing IO when the IO
> system QoS limit doesn't meet the updatedb process's level is too low,
> not solve this?
> 
> In that case the updatedb process will simply block on IO, will hence
> not be runnable and thus not drain your battery.

It will only work for apps that use I/O, but there may be purely CPU-bound
ones that need that kind of approach too.
