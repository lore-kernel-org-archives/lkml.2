Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2FSJLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:11:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35558 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2FSJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:11:13 -0400
Date: Tue, 19 Jun 2012 10:14:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [RFC PATCH] pch_uart: Add eg20t_port lock field, avoid
 recursive spinlocks
Message-ID: <20120619101447.74cbd9a1@pyramind.ukuu.org.uk>
In-Reply-To: <4FDFA09A.4030405@linux.intel.com>
References: <8854635ac5471f8671b93c65e3663eb1cb204c9d.1338454156.git.dvhart@linux.intel.com>
	<CANKRQnhZErpvcsRW3ukNzY0_zv4x=5OzQ-sr+aeuxL63=tQ=4A@mail.gmail.com>
	<4FC90BAD.3080606@linux.intel.com>
	<4FCE8307.3050901@linux.intel.com>
	<CANKRQnj5mxHLprMt4VMMa7sCwLZb=PAktnVVD1MZVkkUG4eLoA@mail.gmail.com>
	<4FDFA09A.4030405@linux.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 14:41:46 -0700
Darren Hart <dvhart@linux.intel.com> wrote:

> 
> 
> On 06/05/2012 04:48 PM, Tomoya MORINAGA wrote:
> > On Wed, Jun 6, 2012 at 7:07 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> >> Are there still concerns about the additional lock? I'll resend V2
> >> tomorrow with the single whitespace fix if I don't hear anything back today.
> > 
> > I understand your saying. Looks good.
> > However, I am not expert of linux-uart core system.
> > So, I'd like UART maintainer to give us your opinion.
> 
> Greg, Alan,
> 
> any concerns with the locking approach I've adopted in the patch?

Only the one I noted in my reply the first time around which is that you
can't permit tty->low_latency=1 unless your tty receive path is not an
IRQ path. From a locking point of view the change makes sense anyway.

Going back over it your console locking also needs care - an oops or
printk within the areas the private lock covers will hang the box. That
should also probably be a trylock style lock as with the other lock on
that path

Alan
