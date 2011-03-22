Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1CVLGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:06:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44767 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754235Ab1CVLGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:06:46 -0400
Date: Tue, 22 Mar 2011 11:07:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oneukum@suse.de>
Cc: Toby Gray <toby.gray@realvnc.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: Prevent data loss when filling tty
 buffer.
Message-ID: <20110322110708.642c568b@lxorguk.ukuu.org.uk>
In-Reply-To: <201103220907.42552.oneukum@suse.de>
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
	<20110321165612.0f764046@lxorguk.ukuu.org.uk>
	<201103220907.42552.oneukum@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 09:07:42 +0100
Oliver Neukum <oneukum@suse.de> wrote:

> Am Montag, 21. März 2011, 17:56:12 schrieb Alan Cox:
> > On Mon, 21 Mar 2011 15:52:25 +0000
> > Toby Gray <toby.gray@realvnc.com> wrote:
> > 
> > > When sending large quantities of data through a CDC ACM channel it is possible
> > > for data to be lost when attempting to copy the data to the tty buffer. This
> > > occurs due to the return value from tty_insert_flip_string not being checked.
> > 
> > For a tty that is normally the right thing to do - no flow control was
> > asserted and the internal 64K of buffering was overrun so discard.
> 
> But should we really randomly discard a part of a buffer?
> If this happens the better alternative approach would be to nuke all buffers
> we currently have.

If you have a stall on a PC eg a hard disk going through a fault sequence
and jamming up the CPU (as PATA can do so well) you don't want to discard
63K of perfectly good PPP frames just because you lost the following one.

It's also of course what the hardware itself does below us so the
behaviour isn't changing, we just provide a somewhat software extended
FIFO.
