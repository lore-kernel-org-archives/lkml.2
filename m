Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1ESOhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:37:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42039 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752850Ab1ESOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:37:16 -0400
Date: Thu, 19 May 2011 15:36:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Timur Tabi <timur@freescale.com>, kumar.gala@freescale.com,
        benh@kernel.crashing.org, akpm@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Message-ID: <20110519153612.726140be@lxorguk.ukuu.org.uk>
In-Reply-To: <20110519142225.GC21441@kroah.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
	<1305813272-31826-7-git-send-email-timur@freescale.com>
	<20110519142225.GC21441@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 07:22:25 -0700
Greg KH <greg@kroah.com> wrote:

> On Thu, May 19, 2011 at 08:54:31AM -0500, Timur Tabi wrote:
> > +/*
> > + * The udbg subsystem calls this function to display a single character.
> > + * We convert CR to a CR/LF.
> > + */
> > +static void ehv_bc_udbg_putc(char c)
> > +{
> > +	if (c == '\n')
> > +		byte_channel_spin_send('\r');
> > +
> > +	byte_channel_spin_send(c);
> > +}
> 
> Why do this conversion in the driver?  Shouldn't that be something that
> userspace worries about?

udbg is a bit before the land of userspace so it needs to do whatever
adaption the firmware/happyvisor interface wants.
