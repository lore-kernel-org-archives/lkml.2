Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab0GVLMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:12:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50247 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757210Ab0GVLME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:12:04 -0400
Date: Thu, 22 Jul 2010 12:21:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mattia Jona-Lasinio <mattia.jona@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <triad@df.lth.se>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, ivan.kuten@promwad.com,
        lcd-linux-users@lists.sourceforge.net,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Subject: Re: Introducing the LCD-Linux project
Message-ID: <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 14:57:54 +0200
Mattia Jona-Lasinio <mattia.jona@gmail.com> wrote:

> Hi,
> 
> this is to introduce the LCD-Linux project (http://lcd-linux.sourceforge.net/),
> a kernel level implementation of a VT102 terminal emulator, optimized for small
> alphanumeric and graphic displays.

The kernel already has a console and that provides an abstract
implementation that is used for everything from text mode displays to vga
to assorted accelerated hardware platforms.

Why do we need a VT102 as well ?

> functions. A solution is therefore to provide a sort of minimal terminal
> emulation in kernel space, that can be accessed through the standard character
> device interface. In this way the problem of the display management is reduced

If you use the existing kernel console interfaces then you don't need to
worry about vt102 v console or having two terminal emulations running.

The basic idea seems sound enough other than that. Another reason for
using the kernel console/vt driver is that you can then also support mini
bitmap displays because a frame buffer driver backed by a driver for a
suitable LCD panel can work nicely because the vt driver can sit on the
fb layer quite happily and fb then implements low level handling for the
pixels.

Alan
