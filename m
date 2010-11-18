Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988Ab0KRRmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:42:00 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49288 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab0KRRl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:41:58 -0500
Date: Thu, 18 Nov 2010 09:41:53 -0800
From: Andres Salomon <dilinger@queued.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during
 boot (v2)
Message-ID: <20101118094153.4515cbc2@queued.net>
In-Reply-To: <4CE54064.6010702@zytor.com>
References: <20101111214546.4e573cad@queued.net>
	<reply-olpc-3-v2@mdm.bga.com>
	<20101112002704.50c629e2@queued.net>
	<20101114095013.GB24206@elte.hu>
	<4CE0B54E.6000101@zytor.com>
	<20101115070254.GA25243@elte.hu>
	<4CE17133.2050101@zytor.com>
	<20101118083420.GC26398@elte.hu>
	<1290078135.22575.4.camel@concordia>
	<4CE54064.6010702@zytor.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 07:04:04 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 11/18/2010 03:02 AM, Michael Ellerman wrote:
> > On Thu, 2010-11-18 at 09:34 +0100, Ingo Molnar wrote:
> >>
> >> Look at the general balance of hardship: very little harm is done
> >> (it's not a big deal if a variable is only used in a single
> >> function) but having it with local variables can be _really_
> >> harmful - for example i overlooked them when i reviewed this
> >> patch. I dont like important details obscured - i like them to be
> >> apparent. Again, this is something that some people can parse
> >> immediately on the visual level 
> >> - me and many others cannot.
> > 
> 
> No, sorry, this sounds like a personal preference that is well out of
> line with the vast majority of C programmers I've ever come across,
> not just in the Linux kernel world but outside of it.


This is actually one of the reasons I specifically like initialized
static variables (inside of functions).  Take the following code:

int foo(void)
{
	static char *frob = NULL;
	int p;

	if (frob) {
		...
	}


Upon seeing that and thinking "whoa, how could frob be
initialized and then checked?", I realize that it's either a bug or I
look back at the initialization and realize that frob is static.  It's
less obvious (to me) with non-explicit initialization.
