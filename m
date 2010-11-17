Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0KQLKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:10:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39541 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753217Ab0KQLKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:10:10 -0500
Date: Wed, 17 Nov 2010 11:08:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>,
        Indan Zupancic <indan@nul.nu>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
Message-ID: <20101117110822.478fdd46@lxorguk.ukuu.org.uk>
In-Reply-To: <20101117053251.GA26928@jasper.tkos.co.il>
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
	<4CE0FE71.6000303@suse.cz>
	<20101115100838.GA3649@jasper.tkos.co.il>
	<4CE10B32.8090705@suse.cz>
	<c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl>
	<20101116110444.2f0cabd9@lxorguk.ukuu.org.uk>
	<4CE28299.30907@suse.cz>
	<20101117053251.GA26928@jasper.tkos.co.il>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 07:32:51 +0200
Baruch Siach <baruch@tkos.co.il> wrote:

> Hi Jiri, Alan,
> 
> On Tue, Nov 16, 2010 at 02:09:45PM +0100, Jiri Slaby wrote:
> > On 11/16/2010 12:04 PM, Alan Cox wrote:
> > > Sixteen devices is way too many for drivers/misc - it only has 256 total
> > > and only half of those are dynamic.
> > 
> > Seconded. (And it's a quarter, not even a half like I already wrote.)
> 
> If I reduce the maximal number of devices to 4, will it make any difference? I 
> don't mind even having a limit of 2 by default, as long as a simple define 
> change is enough to raise this limit.

No look you can need more than two, its not a one off special device it
doesn't use the misc minor space.

Allocate some dynamic device space.

Alan
