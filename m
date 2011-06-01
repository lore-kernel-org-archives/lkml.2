Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab1FAUc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:32:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39815 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753492Ab1FAUc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:32:56 -0400
Date: Wed, 1 Jun 2011 21:34:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
Message-ID: <20110601213427.0021bff7@lxorguk.ukuu.org.uk>
In-Reply-To: <4DE6A013.409@freescale.com>
References: <1306953337-15698-1-git-send-email-timur@freescale.com>
	<20110601204618.32190be9@lxorguk.ukuu.org.uk>
	<4DE6A013.409@freescale.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 15:24:51 -0500
Timur Tabi <timur@freescale.com> wrote:

> Alan Cox wrote:
> > O> +	/* One partition must be local, the other must be remote.  In other
> >> +	   words, if source and target are both -1, or are both not -1, then
> >> +	   return an error. */
> >> +	if ((param.source == -1) == (param.target == -1))
> >> +		return -EINVAL;
> > 
> > Excess brackets (I just mention that one in passing)'
> 
> Do you mean excess parentheses?  If so, then I don't see how.  "(param.source ==
> -1)" and "(param.target == -1)" are expressions that return a boolean.  I'm
> comparing the two boolean results to see if they're equal

Ok - it's a bit non obvious but yes fair enough and it is commented.

> Where exactly in lib/ should it go?  lib/strings.c seems too low-level for a
> function like this.  lib/string_helpers.c is for sprintf-like functions.  And
> it's too generic for lib/powerpc/

I'd submit it to lib/string personally but I'm not sure where would be
better. If someone doesn't like lib/string they can suggest a better
place 8)

> Well, the "handles" are supposed to be just unique numbers.  In this case, they
> are IRQs, but we don't want to expose that.  The application is supposed to scan
> the device tree looking for the doorbell nodes that it wants, and in those nodes
> there is a 'reg' property that contains the handle for that doorbell.  So the
> numbers just need to match.  What they represent is not relevant.

Ok so they are always going to be exposed to users not to drivers, in
which case yes it makes sense. If they are going to get used by kernel
drivers as well an IRQ interface would probably also make sense.

Alan
