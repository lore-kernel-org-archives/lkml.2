Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2KTLGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:06:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60349 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2KTLGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:06:11 -0500
Date: Tue, 20 Nov 2012 11:10:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Russ Anderson <rja@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jack Steiner <steiner@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, rja@americas.sgi.com
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121120111055.64845785@pyramind.ukuu.org.uk>
In-Reply-To: <20121120042855.GE6186@mwanda>
References: <20121117151611.GB16900@elgon.mountain>
	<20121120004834.GE5060@sgi.com>
	<20121120042855.GE6186@mwanda>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 07:28:56 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Mon, Nov 19, 2012 at 06:48:34PM -0600, Russ Anderson wrote:
> > On Sat, Nov 17, 2012 at 06:16:11PM +0300, Dan Carpenter wrote:
> > > This is a static checker fix.  The problem is that we store the bits
> > > from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
> > > shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
> > > them.
> > 
> > Is this the complete patch?  phys_apicid is an int, but gets
> > cast as unsigned long.  Doesn't phys_apicid also have to be
> > changed to unsigned long?  And why ulong instead of uint (on x86_64)?
> 
> Uint is 32bit across all arches in linux and unix, according to
> wikipedia. 

For Linux yes, if Wackypedia claims it for "unix" it's wrong 8) and varies
between 16 and 36bits that I can think of.

If you specifically want 32bits use "u32", it's not going to make any
actual difference to unsigned int but it makes the requirement explicit.

Alan
