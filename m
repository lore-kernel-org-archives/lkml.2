Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0E2HyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 03:54:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:54026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0E2HyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 03:54:08 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <201005282344.49892.rjw@sisk.pl>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <1275052817.1645.64.camel@laptop> <1275058794.27810.9571.camel@twins>
	 <201005282344.49892.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 29 May 2010 09:53:37 +0200
Message-ID: <1275119617.27810.12634.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 23:44 +0200, Rafael J. Wysocki wrote:
> Consider updatedb or another file indexing ... thing on a laptop.  I certainly
> don't want anything like this to run and drain my battery, even if it has
> already been started when the machine was on AC power.  Now, of course,
> I can kill it, but for that I need to notice that it's running and it presumably
> might have done some job already and it would be wasteful to lose it.
> It would be quite nice if that app was not regarded as runnable when the
> system was on battery power. 

How will a ionice on steriods that will defer servicing IO when the IO
system QoS limit doesn't meet the updatedb process's level is too low,
not solve this?

In that case the updatedb process will simply block on IO, will hence
not be runnable and thus not drain your battery.
