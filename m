Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab1ETNXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:23:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52021 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756018Ab1ETNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:23:48 -0400
Date: Fri, 20 May 2011 14:24:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH]: Fix Ultrastor asm snippet
Message-ID: <20110520142459.4c37d3e0@lxorguk.ukuu.org.uk>
In-Reply-To: <20110520130215.GB3428@infradead.org>
References: <20110518150605.GA25262@const.bordeaux.inria.fr>
	<20110520130215.GB3428@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 09:02:15 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, May 18, 2011 at 05:06:05PM +0200, Samuel Thibault wrote:
> > Commit 1292500b replaced
> > 
> > "=m" (*field) : "1" (*field)
> > 
> > with
> > 
> > "=m" (*field) :
> > 
> > with comment "The following patch fixes it by using the '+' operator on
> > the (*field) operand, marking it as read-write to gcc."
> > '+' was actually forgotten.  This really puts it.
> 
> Do you actually have the hardware or was this just a code audit?
> 
> I have the strong suspicion that this driver is pretty much dead and
> bitrotting.

There are a pile of scsi drivers like the Ultrastor that probably want
retiring via staging.

I can believe an AHA152x or two lurk around, and the odd NCR53c80 and
clones because they were so voluminous but the rest I doubt somewhat.
