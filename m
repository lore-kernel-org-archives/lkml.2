Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0JDWvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:51:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:39541 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0JDWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:51:01 -0400
Subject: Re: Introduce support for little endian PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Ian Munsie <imunsie@au1.ibm.com>
In-Reply-To: <1286188242.15020.349.camel@thor.local>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
	 <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
	 <1285935283.2463.78.camel@pasglop>  <1285950041.15020.272.camel@thor.local>
	 <1285966204.2463.137.camel@pasglop> <1286188242.15020.349.camel@thor.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 09:50:32 +1100
Message-ID: <1286232632.2463.324.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 12:30 +0200, Michel Dänzer wrote:

> > And last I looked X still pukes if you give it a pixmap in non native
> > byte order but that might have been fixed.
> 
> I'm not sure what exactly you mean by that, but I'm not aware of any
> such issues offhand.

Hrm, I meant on the DDX side. Anyways, doesn't matter. Even if it works
fine on X side. Fact is, there's tons and tons of existing SW stack and
drivers on the field that are totally incapable of doing BE and
essentially unfixable without major work that the customer(s) is(are)
unwilling to do at this stage.

(Think embedded gfx IP cores mostly, including codecs etc...)

> I didn't say anything about that, just that IME it should be mostly
> possible to deal with endianness within the driver stack.

To some extent yes. Completely, I'm not sure. Apps manipulating pixels,
such as video players doing hand-made overlay etc... will potentially
have issues. It's more than actual pixel byte ordering. It's anything
that accesses a quantity in memory using different size accessors, ie,
storing a u32 and then expecting to find the LSB at u8* of the same
address etc... that sort of stuff happens more often in gfx-oriented
code than anywhere else in my experience.

> Note that I'm not arguing against these changes, just pointing out some
> apparent inaccuracies in the reasoning for them.

Right, I possibly made an incorrect statement relative to Xorg (I had
assumed the fb layer only worked properly in native endian format), but
that doesn't matter much since the problem here is existing code &
drivers and goes way beyond X (probably no X on the target setups
anyways).

Cheers,
Ben

