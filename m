Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab1ESRYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:24:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57413 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933494Ab1ESRYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:24:39 -0400
Date: Thu, 19 May 2011 18:25:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Message-ID: <20110519182551.0c06cd10@lxorguk.ukuu.org.uk>
In-Reply-To: <4DD545E4.9090408@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
	<1305813272-31826-7-git-send-email-timur@freescale.com>
	<20110519153358.5876f310@lxorguk.ukuu.org.uk>
	<4DD545E4.9090408@freescale.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 11:31:32 -0500
Timur Tabi <timur@freescale.com> wrote:

> Alan Cox wrote:
> > You really also need a hangup method so vhangup() does the right thing
> > and you can securely do logins etc and sessions on your console. As
> > you've got no hardware entangled in this and you already use tty_port
> > helpers the hangup helper will do the work for you.
> 
> So all I need is this?
> 
> static void ehv_bc_tty_hangup(struct tty_struct *ttys)
> {
> 	struct ehv_bc_data *bc = ttys->driver_data;
> 
> 	tty_port_hangup(&bc->port);
> }
> 
> I've noticed that some drivers flush their transmit buffers before calling
> tty_port_hangup(), but some others don't.  Should I do this too?  I don't know
> if hangup should be as quick as possible.

Doesn't matter too much. If you can flush it quickly then do so
