Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2BMRXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:23:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57785 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab2BMRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:23:52 -0500
Date: Mon, 13 Feb 2012 17:25:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: avoid false positive warnings on ioctl to
 partition
Message-ID: <20120213172527.40ac390b@pyramind.ukuu.org.uk>
In-Reply-To: <1329153206-31355-1-git-send-email-pbonzini@redhat.com>
References: <1329153206-31355-1-git-send-email-pbonzini@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Therefore, this patch silently blocks all ioctls except SG_IO, since
> all of them turned out to be false positives; in case some escaped, it
> should be easily diagnosable or at least bisectable.  The warning text
> is separated for root and non-root, and the deprecation period for root
> users is set to end a year from now.

NAK.

Firstly blocking CAP_SYS_RAWIO access by any means to a partition is
itself nonsense as the process has enough privilege to go poke the
controller I/O registers by hand. That's a gratuitious API breakage.

Secondly SG_IO allows users to read and write blocks outside their partition as
far as I can see from the verify logic. You either need to block it or
smarten up the filter.

What were the SG_IO command blocks that were caught ? It's going to be
pretty trivial to add a filter->partition_ok to some of them if need be.

Anyway it fails both by stopping valid stuff and not stopping insecure and
unsafe stuff.

Alan
