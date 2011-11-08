Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1KHApn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:45:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59744 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680Ab1KHApa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:45:30 -0500
Date: Tue, 8 Nov 2011 00:46:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Davidlohr Bueso <dave@gnu.org>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111108004615.39477beb@lxorguk.ukuu.org.uk>
In-Reply-To: <20111108002520.GB25769@tango.0pointer.de>
References: <1320614101.3226.5.camel@offbook>
	<20111107112952.GB25130@tango.0pointer.de>
	<1320675607.2330.0.camel@offworld>
	<20111107135823.3a7cdc53@lxorguk.ukuu.org.uk>
	<CAPXgP117Wkgvf1kDukjWt9yOye8xArpyX29xx36NT++s8TS5Rw@mail.gmail.com>
	<20111107225314.0e3976a6@lxorguk.ukuu.org.uk>
	<20111107230712.GA25769@tango.0pointer.de>
	<20111107234337.1dc9d612@lxorguk.ukuu.org.uk>
	<20111108002520.GB25769@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And half of the other resource limits are "oddities" too?
> For  example RLIMIT_SIGPENDING is per-user and so is RLIMIT_MSGQUEUE,
> and others too.

When you look at the standards - yes.

> > And the standards have no idea how a resource limit hit for an fs would
> > be reported, nor how an app installer would check for it. Quota on the
> > other hand is defined behaviour.
> 
> EDQUOT is POSIX, but afaik there is no POSIX standardized API for quota,
> is there? i.e. the reporting of the user hitting quota is defined, but

Its part of Unix and its well defined and used by applications, both for
hitting quota (the easy bit), checking quota (when checking space for
things particularly), and manipulating them

The latter bit is nice, it means you can mount with a user quota set in
the mount options, and if you want then use quota tools to change the
quota of a specific user or two that have special rules.

Alan
