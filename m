Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0FSJ1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:27:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42392 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755191Ab0FSJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:27:07 -0400
Date: Sat, 19 Jun 2010 10:30:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100619103056.194fb221@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Typically, one would push a config patch to enable and disable the feature and
> patch the distribution.  However, in some cases this is not feasible in order

If you can push a patch to set the flag you can push a patch to panic or
reject that combination.

Devil's advocate time: 

Also the fact some distributions chose a binary compatible interface for
their internal modules was their choice. It is one that has been
repeatedly rejected by upstream and at kernel summit.

So given we fundamnetally reject your approach why should we carry your
flag ?

> In some cases the distribution may want to allow booting of these features but
> explicitly notify a user that they are not "officially" supported.  It is also

We have printk. You can add a module of your own which indicates
'support' status too.

> possible that the hardware is fixed via a firmware update at a later date,
> making it supported again.

IMHO it's not properly named in the first place. You are talking about
combinations of hardware/firmware and you actually mean 'configuration
not supported' ?

> This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for distributions
> to use.

and why KERN_CRIT when the other printk's don't use that level ?

A suggestion: instead of all this push a single patch with a comment and
maybe defines indicating that taint flag bits 28-31 are 'reserved' for
experimental and out of tree applications.

That way anyone who has a requirement like yours can deal with it and
nobody has to worry about bit collisions, naming and the like. Nor if you
suddenely need an extra bit in 3 years time are you going to come unstuck
on your KABI. That will help other people doing experiments with taint or
with differing needs to the Red Hat one.

Alan
