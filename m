Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0K2Xdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:33:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42422 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754299Ab0K2Xdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:33:41 -0500
Date: Mon, 29 Nov 2010 23:31:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, w@1wt.eu
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101129233150.60a3c3af@lxorguk.ukuu.org.uk>
In-Reply-To: <20101129163308.GA2383@xanatos>
References: <20101116104600.GA24015@suse.de>
	<20101119191906.GA31760@xanatos>
	<AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
	<20101126074809.GD19589@elte.hu>
	<20101129163308.GA2383@xanatos>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	/* Some debugging symbols have no name.  Ignore them. */
> > -	if (!iter->name[0])
> > +	if (!iter->name[0] || !capable(CAP_SYS_ADMIN))
> >  		return 0;

This is hardcoding file permission policy into the kernel in a way the
user cannot change - its bogus in the extreme. Use file permissions that
way saner people can chmod them as they like. Indeed quite a few people
*already* chmod chunks of /proc.

It also means that things like SELinux and Tomoyo can be used to manage
security on it in clever ways - something that using a capability
completely buggers up.

Alan
