Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935369Ab1ETJxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:53:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34411 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752839Ab1ETJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:53:08 -0400
Date: Fri, 20 May 2011 10:54:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Message-ID: <20110520105417.562c7341@lxorguk.ukuu.org.uk>
In-Reply-To: <4DD53FDD.7070503@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
	<1305813272-31826-7-git-send-email-timur@freescale.com>
	<20110519153358.5876f310@lxorguk.ukuu.org.uk>
	<4DD53FDD.7070503@freescale.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 11:05:49 -0500
Timur Tabi <timur@freescale.com> wrote:

> Alan Cox wrote:
> >> > +		/* Pass the received data to the tty layer.  Note that this
> >> > +		 * function calls tty_buffer_request_room(), so I'm not sure if
> >> > +		 * we should have also called tty_buffer_request_room().
> >> > +		 */
> >> > +		ret = tty_insert_flip_string(ttys, buffer, len);
> 
> > You only need to request_room in advance if you can't handle the case
> > where the insert_flip_string returns less than you stuffed down it.
> 
> If tty_insert_flip_string() returns less than I stuffed down it, the characters
> it didn't accept will be dropped.  That's because once I receive them, I have
> nowhere else to put them.  I suppose I could implement a receive FIFO, but that
> seems overkill.  If calling tty_buffer_request_room() ensures that
> tty_insert_flip_string() always accepts all the characters, I would rather do that.

I was answering the question in the comment in the code...

