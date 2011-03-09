Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1CIEkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 23:40:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:34822 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab1CIEk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 23:40:28 -0500
Message-ID: <62749.94.211.195.167.1299645589.squirrel@gate.crashing.org>
In-Reply-To: <AANLkTikAnb39XhR0hdZAzTKGJ-P1rH+ZxtD+Dea7-364@mail.gmail.com>
References: <4D6E8932.1010405@zytor.com>
    <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
    <4D6EB07C.5040004@zytor.com>
    <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
    <4D6ECBDB.6090307@zytor.com> <20110303083035.GB14854@elte.hu>
    <AANLkTik4aTN8+Ob_GVwF17v6pDNGg2DEZJubBazs2e3L@mail.gmail.com>
    <1299619716.22236.32.camel@pasglop>
    <AANLkTikAnb39XhR0hdZAzTKGJ-P1rH+ZxtD+Dea7-364@mail.gmail.com>
Date: Wed, 9 Mar 2011 05:39:49 +0100 (CET)
Subject: Re: RFC: x86: kill binutils 2.16.x?
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: "Kyle Moffett" <kyle@moffetthome.net>
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        "Kyle Moffett" <kyle.d.moffett@boeing.com>,
        "Kumar Gala" <kumar.gala@freescale.com>
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is not with the kernel compile itself, but with the 2.12
> "dssall" binutils test.  Basically, recent binutils treats e500 as
> effectively a separate architecture that happens to share *most* of
> the opcodes with regular PowerPC.  Any opcode which is not understood
> by the e500 chip is either convert to an equivalent opcode which is
> understood (IE: lwsync => sync), or failed with an error.  This means
> that the kernel compile aborts early telling me to upgrade to a newer
> version of binutils.

$ echo dssall | powerpc-linux-as -many -me500
$ powerpc-linux-objdump -d a.out | grep 0:
   0:   7e 00 06 6c     dssall
$ powerpc-linux-as --version | head -1
GNU assembler (GNU Binutils) 2.21.51.20110309


What version of binutils does not work?  (I also checked with
-me500x2, -me500mc, -mspe, and various combinations.  lwsync
is indeed converted to a regular sync (well, "msync") for e500
and e500x2).


Segher

