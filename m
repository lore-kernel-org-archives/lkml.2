Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0KFKiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 06:38:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41721 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754425Ab0KFKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 06:38:13 -0400
Date: Sat, 6 Nov 2010 10:36:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ltuikov@yahoo.com
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] [USB] UAS: Achitecture; TMF; more
Message-ID: <20101106103650.6d4a5342@lxorguk.ukuu.org.uk>
In-Reply-To: <87456.32791.qm@web31801.mail.mud.yahoo.com>
References: <20101106051447.GA2327@kroah.com>
	<87456.32791.qm@web31801.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I did want to submit them one at a time. I really did. But one change
> necessitated another in order to keep things consistent, and it ended
> up like this, one single commit in my git tree.

You can still dice it up into small bits.

Having done this before a few times when I've ended up in the same
situation (either by my own lack of planning or by being handed a blob by
and told my job is to sort it out) a few tips.

First start with the trivial bits - for example you can easily pull out
patches like

1. Add packed to dats structures that match the wire format
2. Correct the layout of sense iu
3. Add common initialisers
4. Clean up URB freeing

And while you are at it you can also lose changes by removing gratiutious
stuff like

-struct uas_dev_info {
+/* Lives in the SCSI host, hostdata points to it.
+ */
+struct uas_tport_info {


Now even if you hate the name or the qdepth field name you can deal with
it later once it is all nicely working. That would clean up the patch
noise a lot in itself

As you do that the rest becomes clearer and you can then recommit stuff
step by step. The patches need to tell a story which is "How we got from
A to B in small clearly logical steps without breaking anything on the
way"

The tagging mix should possibly also be discussed with the scsi list,
that may be the better place to fix it.

Alan
