Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2IFMrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:47:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46345 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2IFMrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:47:40 -0400
Date: Thu, 6 Sep 2012 13:51:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        ananth@in.ibm.com
Subject: Re: [PATCH] [mcelog] Start using the new sysfs tunables location
Message-ID: <20120906135110.6dadb023@pyramind.ukuu.org.uk>
In-Reply-To: <50489853.3050906@linux.vnet.ibm.com>
References: <20120905102156.9423.27806.stgit@localhost.localdomain>
	<20120905103237.9726.56131.stgit@localhost.localdomain>
	<20120905184708.GC16230@one.firstfloor.org>
	<CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com>
	<20120906122850.GI17289@tassilo.jf.intel.com>
	<50489853.3050906@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2012 18:04:27 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> wrote:

> On 09/06/2012 05:58 PM, Andi Kleen wrote:
> >> The change is still under discussion. Stage one is to add the new global
> >> pathnames in addition to keeping the old per-cpu ones. Also fix all utilities
> >> (just mcelog(8) as far as we know) to prefer the new paths.
> >
> > But why do you even want to change it?  Does it fix anything?
> > AFAIK the old setup -- while not being pretty -- works just fine.
> 
> The reason for this was explained in this thread:
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg298302.html
> 
> Even if we decide not to remove these tunables from under their current 
> per-cpu location, I still think it is much cleaner to have them 
> available under /sys/devices/system/machinecheck.

That to me seems a ridiculous proposal. What are you going to do if in
future they ceased to be system wide ? Move them back ?

The threshold for playing musical chairs with sysfs nodes is a lot higher
than "I think it's much cleaner"

The current approach is a lot more futureproof even if a spot more ugly.

Alan
