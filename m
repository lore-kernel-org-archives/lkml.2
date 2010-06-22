Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0FVQxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:53:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45682 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753857Ab0FVQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:53:22 -0400
Date: Tue, 22 Jun 2010 17:57:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100622175741.6541ff2a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100622163817.GE20668@srcf.ucam.org>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
	<20100617091322.b7d21473.randy.dunlap@oracle.com>
	<4C1A7D61.8010900@redhat.com>
	<20100621122145.76ebd7ac.akpm@linux-foundation.org>
	<20100621194559.GI3217@redhat.com>
	<20100621130008.d3dc01a8.akpm@linux-foundation.org>
	<20100622153457.GA5381@redhat.com>
	<20100622164835.4ddb9432@lxorguk.ukuu.org.uk>
	<20100622163817.GE20668@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 17:38:17 +0100
Matthew Garrett <mjg@redhat.com> wrote:

> On Tue, Jun 22, 2010 at 04:48:35PM +0100, Alan Cox wrote:
> > > +	printk(KERN_CRIT "UNSUPPORTED HARDWARE DEVICE: %s\n", msg);
> > > +	WARN_TAINT(1, TAINT_HARDWARE_UNSUPPORTED,
> > > +		   "Your hardware is unsupported.  Please do not report "
> > > +		   "bugs, panics, oopses, etc., on this hardware.\n");
> > 
> > And as already pointed out it's not unsupported hardware even in the case
> > you described
> 
> It's hardware that isn't supported by the vendor. How is it not 
> unsupported hardware in that context?

Which vendor ? What do you mean by support ? Even in Red Hat you will
I suspect need to change that message because after the first 500 calls
received by Dell or HP or whoever about it they'll demand you add
"unsupported by Red Hat" or similar to avoid them getting support calls !

And then as I said originally the example given was not even
"unsupported hardware" for an obvious Red Hat definition of the two
because it was actually about firmware combinations on specific boards -
ie it was an unsupported configuration.

The trouble in part is that the moment you borrow a bit for Red Hat
private use and put that use into the kernel you've made it unusuable for
anyone else. If you simply mark a few bits 'private/experimental use'
then you can use it for "unsupported" but others can use it for things
like 'uncertified configuration' or 'test' or 'non vendor signed module
loaded' and so on. All valid uses in specific vendor customisations.

The other giggle of course is that the WARN says do not report, but the
existing oops capturing software will capture the WARN so auto-report it.

Alan
