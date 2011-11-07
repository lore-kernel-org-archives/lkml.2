Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1KGWwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:52:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58234 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab1KGWwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:52:30 -0500
Date: Mon, 7 Nov 2011 22:53:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Davidlohr Bueso <dave@gnu.org>, Lennart Poettering <mzxreary@0pointer.de>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111107225314.0e3976a6@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPXgP117Wkgvf1kDukjWt9yOye8xArpyX29xx36NT++s8TS5Rw@mail.gmail.com>
References: <1320614101.3226.5.camel@offbook>
	<20111107112952.GB25130@tango.0pointer.de>
	<1320675607.2330.0.camel@offworld>
	<20111107135823.3a7cdc53@lxorguk.ukuu.org.uk>
	<CAPXgP117Wkgvf1kDukjWt9yOye8xArpyX29xx36NT++s8TS5Rw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What part of the message did you read? This is about _per_user_
> limits, not global limits!

What part of 'we support lots of mounts' don't you understand. Or perhaps
you could go use a control group for it ?

> Any untrusted user can fill /dev/shm today and DOS many services that
> way on any machine out there. Same for /tmp when it's a tmpfs, or
> /run/user. This is an absolutely unacceptable state and needs fixing.

Actually if you've mounted it with limits they can be a nuisance but
little more, and if you are running with memory overcommit disabled then
its accounted for in that. If you are running with memory over commit
allowed (as eg Red Hat and Fedora do) you are peeing into the wind at this
point anyway so wasting time.

> I don't care about which interface it is, if someting else fits
> better, let's discuss that, but it has surely absolutely noting to do
> with size/nr_blocks/nr_inodes.

Per user would be quota, per process would be rlimit. Quite simple
really, nice standard interfaces we've had for years. Various systems
have been quotaing /tmp/ for a long time. Smart secure ones of course
mount a per user /tmp via PAM or similar to avoid /tmp attacks and in that
case the mount options I pointed out already do the job.

Quota isn't entirely trivial because you want your quota db initialised
at mount so you'd need to pass a quota file pointer to the mount command
ideally. All doable however and makes the management easy and means you
get all the application expected behaviour when you exceed your limits
(that is for properly written stuff - lots of crappy badly written desktop
programs randomly crash or worse as we already know)

This is why I'm confused - you are wittering about all sorts of security
stuff but you are not addressing the more serious matters first - the
ones that go beyond a DoS.

Alan
