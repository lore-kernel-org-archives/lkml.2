Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0DUT5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:57:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:60416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab0DUT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:57:18 -0400
Subject: Re: Considerations on sched APIs under RT patch
From: Peter Zijlstra <peterz@infradead.org>
To: Primiano Tucci <p.tucci@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
In-Reply-To: <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 21:57:13 +0200
Message-ID: <1271879833.1776.186.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 21:24 +0200, Primiano Tucci wrote:
> Is it sure that calling a scheduler api won't induce a re-scheduling
> of the caller process (e.g. as in the case of a lock held by another
> processor)? It would be very unpleasant if the scheduling apis can
> induce re-scheduling, making the realization of a Real Time scheduling
> infrastructure completely un-deterministic. 

No, any syscall can end up blocking/scheduling there are no exceptions.
But blocking doesn't mean its non-deterministic, esp. when coupled with
things like PI.

But you do have to treat system resources as such, that is they can (and
will) create cross-cpu dependencies, if you do not take that into
account you will of course be surprised.



