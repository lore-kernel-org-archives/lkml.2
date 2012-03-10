Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2CJM65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 07:58:57 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47390 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab2CJM64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 07:58:56 -0500
Date: Sat, 10 Mar 2012 13:00:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lkcl luke <luke.leighton@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Subject: Re: [advice sought] EOMA68 kernel support
Message-ID: <20120310130055.5bd5263a@pyramind.ukuu.org.uk>
In-Reply-To: <CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
References: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
	<CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012 06:45:15 +0000
lkcl luke <luke.leighton@gmail.com> wrote:

> On Fri, Mar 9, 2012 at 10:41 PM, lkcl luke <luke.leighton@gmail.com> wrote:
> 
> > the implications of that split, for the linux kernel source code, are
> > a bit... scarey :)
> 
>  ... so, real simple very basic, concrete and necessary question:
> where the hell in the linux kernel tree should support for eoma68 be
> added??

It sounds to me like a bus.

>  * driver support can't be added to drivers/ because although a device
> with an EOMA68 CPU card *requires* drivers, it's not *actual* drivers
> being added, it's driver *grouping* code that's required, and that
> concept simply does... not... exist.

Actually we stick busses in drivers too (see pci...)

>  * architecture support can't be added to arch/ because that contains
> code for CPUs not code that is about helping to support multiple CPUs.
>  eoma isn't a CPU.

See above.. it's a bus

> very basic question.  where the hell should EOMA support source code go?
> 
> bearing in mind that the first CPU card is an Allwinner A10, the next
> one is likely to be an AMD Fusion, the one after that could be from
> icubecorp, the one after that a multi-core SMP xtensa, etc.

Off the top of my head I suspect you want

drivers/eoma68/

which is the bus interface and glue including reading the device tree
data for the current board you are plugged into and building a device
tree from that.

lib/eoma68

or some similar name, which is the library routines everything using
eoma68 needs

arch/[x86.arm,..]/platform/eoma68/..

probably the platform code for each system.


I don't btw see the problem with your device trees and display. If you've
got a device tree on *both* the CPU card and the I/O boards then you've
got all the data in the right places.

Alan
